/*
--- APPLY ---
01 - S3 Backend
02 - VPC
03 - EC2
04 - Ansible
05 - Cloudwath

--- DESTROY ---
01 - Cloudwath
02 - EC2
03 - VPC
04 - S3 Backend
*/

def showInput(inputTxt) {
  timeout(time: 15, unit: 'MINUTES') {
    input inputTxt
  }
}

def prettySh(scriptToRun, returnStdout = false) {
  if (returnStdout) {
    echo "WARN: Since stdout will be returned, it'll only be printed at the end of the execution"

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
      output = sh(
        script: scriptToRun,
        returnStdout: returnStdout
      )

      echo "${output}"
    }

    return output
  }

  wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
    sh "${scriptToRun}"
  }
}

def initTerraformModule(moduleName, environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey) {
  withCredentials([sshUserPrivateKey(credentialsId: 'github_robot', keyFileVariable: 'SSH_KEYFILE')]) {
    prettySh("cp -f scripts/jenkins-ssh-wrapper terraforms/${moduleName}")
    prettySh("cp -f terraforms/configs/${environmentToDeploy}/${environmentToDeploy}-init.tfvars terraforms/${moduleName}/init.tfvars")
    prettySh("cp -f terraforms/configs/${environmentToDeploy}/${environmentToDeploy}-vars.tfvars terraforms/${moduleName}/vars.tfvars")
    prettySh("cp -f terraforms/configs/base-tags.tfvars terraforms/${moduleName}/default-tags.tfvars")

    dir("terraforms/${moduleName}") {
      prettySh("rm -fr .terraform")

      echo "Initializing terraform for ${moduleName}.."

      prettySh(
        "KEYFILE=\"${SSH_KEYFILE}\" \
        GIT_SSH=\"./jenkins-ssh-wrapper\" \
        AWS_ACCESS_KEY_ID=\"${awsAccessKey}\" \
        AWS_SECRET_ACCESS_KEY=\"${awsSecretKey}\" \
        terraform init -backend-config=\"./init.tfvars\""
      )
    }
  }
}

def planTerraformModule(moduleName, environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey, extraArgs = "") {
  initTerraformModule(moduleName, environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
  dir("terraforms/${moduleName}") {

    echo "Planning terraform for ${moduleName}.."

    prettySh(
      "AWS_ACCESS_KEY_ID=\"${awsAccessKey}\" \
      AWS_SECRET_ACCESS_KEY=\"${awsSecretKey}\" \
      terraform plan \
      -var-file='./default-tags.tfvars' \
      -var-file='./vars.tfvars' \
      ${extraArgs} \
      -out='./plan.out'"
    )
  }
}

def planDestroyTerraformModule(moduleName, environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey, extraArgs = "") {
  initTerraformModule(moduleName, environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)

  dir("terraforms/${moduleName}") {
    echo "Planning destroy terraform for ${moduleName}.."

    prettySh(
      "AWS_ACCESS_KEY_ID=\"${awsAccessKey}\" \
      AWS_SECRET_ACCESS_KEY=\"${awsSecretKey}\" \
      terraform plan -destroy \
      -var-file='./default-tags.tfvars' \
      -var-file='./vars.tfvars' \
      ${extraArgs}"
    )
  }
}

def applyTerraformPlan(moduleName, awsAccessKey, awsSecretKey, returnStdout = false) {
  dir("terraforms/${moduleName}") {
    echo "Applying terraform for ${moduleName}.."

    prettySh(
      "AWS_ACCESS_KEY_ID=\"${awsAccessKey}\" \
      AWS_SECRET_ACCESS_KEY=\"${awsSecretKey}\" \
      terraform apply -auto-approve ./plan.out",

      returnStdout
    )
  }
}

def destroyTerraformPlan(moduleName, awsAccessKey, awsSecretKey, extraArgs = "") {
  dir("terraforms/${moduleName}") {
    echo "Destroying terraform for ${moduleName}.."

    prettySh(
      "AWS_ACCESS_KEY_ID=\"${awsAccessKey}\" \
      AWS_SECRET_ACCESS_KEY=\"${awsSecretKey}\" \
      terraform destroy \
      -var-file='./default-tags.tfvars' \
      -var-file='./vars.tfvars' \
      ${extraArgs} \
      -auto-approve"
    )
  }
}

def applyTerraformS3(moduleName, awsAccessKey, awsSecretKey, returnStdout = false) {
  try {
    applyTerraformPlan(moduleName, awsAccessKey, awsSecretKey)
  } catch (Exception e) {
    echo 'Nothing to commit'
  }
}

def runAnsible() {
  dir("ansible") {
    echo "Running Ansible ..."
    prettySh(
      "ansible-playbook -i inventory -b main.yml"
    )
  }
}

def getCurrentGitCommitHash() {
  prettySh("git log -n 1 --pretty=format:'%H'", true)
}

pipeline {
  //agent any 
  agent { label 'jenkins-docker-slave1 || jenkins-docker-slave2 || jenkins-docker-slave3 || jenkins-docker-slave4' }

  options {
    ansiColor('xterm')
  }

  environment {
    environmentToDeploy = 'undefined'
    releaseId = 'undefined'
    buildId = 0

    ec2PublicIP = 'undefined'
    ec2PrivateKey = 'undefined'

    awsAccessKey = 'undefined'
    awsSecretKey = 'undefined'

    accessKeyLab = credentials('pipeline-aws-access-key')
    secretKeyLab = credentials('pipeline-aws-secret-key')

    accessKeyProd = credentials('pipeline-aws-access-key')
    secretKeyProd = credentials('pipeline-aws-secret-key')
  }

  stages{
    stage('Checkout + Configs') {
      steps{
        step([$class: 'WsCleanup'])
        checkout scm

        script {
          releaseId = getCurrentGitCommitHash()
          buildId = currentBuild.number
  
          if (env.BRANCH_NAME == 'main') {
            environmentToDeploy = 'prod'
            awsAccessKey = accessKeyProd
            awsSecretKey = secretKeyProd
          } else {
            environmentToDeploy = 'lab'
            awsAccessKey = accessKeyLab
            awsSecretKey = secretKeyLab
          }
        }
        echo "DEBUG: Release ${releaseId}; Build ${buildId}"
      }
    }

    stage('User Input - Choose Action') {
      steps {
        script {
          env.STAGE_ANSWER = input message: 'Apply or Destroy ?', ok: 'Proceed!',
            parameters: [choice(name: 'STAGE_ANSWER', choices: 'apply\ndestroy', description: 'Do you want apply or destroy AWS ?')]
        }
        echo "${env.STAGE_ANSWER}"
      }
    }

    stage('Applying S3 Backend') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        planTerraformModule('s3-backend', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
        applyTerraformS3('s3-backend', awsAccessKey, awsSecretKey)
      }
    }

    stage('Planning VPC') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        planTerraformModule('vpc', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }


    stage('Applying VPC') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        showInput('Apply VPC ?')
        applyTerraformPlan('vpc', awsAccessKey, awsSecretKey)
      }
    }

    stage('Planning EC2') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        planTerraformModule('ec2', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Applying EC2') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        showInput('Apply EC2 ?')
        applyTerraformPlan('ec2', awsAccessKey, awsSecretKey)
      }
    }

    stage('Running Ansible') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        showInput('Run Ansible ?')
        runAnsible()
      }
    }

    stage('Planning Cloudwatch') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        planTerraformModule('cloudwatch', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Applying Cloudwatch') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'apply' }
      }
      steps{
        showInput('Apply Cloudwatch ?')
        applyTerraformPlan('cloudwatch', awsAccessKey, awsSecretKey)
      }
    }


// ------------------------- DESTROY ---------------------------- //

    stage('Planning Destroy Cloudwatch') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        planDestroyTerraformModule('cloudwatch', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Destroying Cloudwatch') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        showInput('Destroy Cloudwatch ?')
        destroyTerraformPlan('cloudwatch', awsAccessKey, awsSecretKey)
      }
    }

    stage('Planning Destroy EC2') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        planDestroyTerraformModule('ec2', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Destroying EC2') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        showInput('Destroy EC2 ?')
        destroyTerraformPlan('ec2', awsAccessKey, awsSecretKey)
      }
    }

    stage('Planning Destroy VPC') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        planDestroyTerraformModule('vpc', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Destroying VPC') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        showInput('Destroy VPC ?')
        destroyTerraformPlan('vpc', awsAccessKey, awsSecretKey)
      }
    }

    stage('Planning Destroy S3 Backend') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        planDestroyTerraformModule('s3-backend', environmentToDeploy, buildId, releaseId, awsAccessKey, awsSecretKey)
      }
    }

    stage('Destroying S3 Backend') {
      when {
        expression { "${env.STAGE_ANSWER}" == 'destroy' }
      }
      steps{
        showInput('Destroy S3 Backend ?')
        destroyTerraformPlan('s3-backend', awsAccessKey, awsSecretKey)
      }
    }
  }
}

