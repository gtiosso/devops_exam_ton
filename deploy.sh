#!/bin/bash

USAGE="Usage: ${0} --access_key 'ACCESS_KEY' --secret_key 'SECRET_KEY' --environment 'ENVIRONMENT' (-a|--apply|-d|--destroy) (-h|--help)
OPTIONS:
--access_key: AWS Access Key for authentication
--secret_key: AWS Secret Key for authentication
--environment: Desired environment (prod or lab)
-a|--apply: Apply terraform to create or update all resources on AWS
-d|--destroy: Destroy all resources on AWS
-h|--help: Show this guide
"

while [[ $# -gt 0 ]]
do
    key="$1"
    
    case $key in
        --access_key)
            ACCESS_KEY="$2"
            shift
            shift
        ;;
        --secret_key)
            SECRET_KEY="$2"
            shift
            shift
        ;;
        --environment)
            ENVIRONMENT="$2"
            shift
            shift
        ;;
        -a|--apply)
	    if [[ -z ${ACTION} ]]
	    then
                ACTION="apply"
                shift
	    else
		echo "Option Conflict (Apply and Destroy), please choose only one!"
                echo -e "${USAGE}"
                exit 1
	    fi
        ;;
        -d|--destroy)
	    if [[ -z ${ACTION} ]]
	    then
                ACTION="destroy"
                shift
	    else
		echo "Option Conflict (Apply and Destroy), please choose only one!"
                echo -e "${USAGE}"
                exit 1
	    fi
        ;;
        -h|--help)
           echo -e "${USAGE}"
           exit 0
        ;;
        *)
            echo "Unknown Option"
            echo -e "${USAGE}"
            exit 1
        ;;
    esac
done

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MODULES_PATH="${BASEDIR}/terraforms"

execTerraform() {
    if [[ ${ACTION} == "apply" ]]
    then
	EXEC_ORDER="s3-backend vpc ec2 cloudwatch"
    elif [[ ${ACTION} == "destroy" ]]
    then
	EXEC_ORDER="cloudwatch ec2 vpc s3-backend"
	PLAN_OPTION="-destroy"
    fi

    for module in ${EXEC_ORDER} 
    do
        cp -f terraforms/configs/${ENVIRONMENT}/${ENVIRONMENT}-init.tfvars terraforms/${module}/init.tfvars
        cp -f terraforms/configs/${ENVIRONMENT}/${ENVIRONMENT}-vars.tfvars terraforms/${module}/vars.tfvars
        cp -f terraforms/configs/base-tags.tfvars terraforms/${module}/default-tags.tfvars
        
	cd ${MODULES_PATH}/${module}
	
	echo "Initializing module ${module}..."
	terraform init -backend-config='./init.tfvars'

	echo "Planning module ${module} for ${ACTION}..."
        terraform plan ${PLAN_OPTION} -var-file='./default-tags.tfvars' -var-file='./vars.tfvars'

	echo
	read -e -p "${ACTION} ${module} ? [Y/n]: " ANSWER
	ANSWER=${ANSWER:-Y}
	if [[ ${ANSWER} == "Y" ]] || [[ ${ANSWER} == "y" ]]
	then
	    echo "Performing ${ACTION} on module ${module}..."
    	    terraform ${ACTION} -var-file='./default-tags.tfvars' -var-file='./vars.tfvars' -auto-approve
	    rm -rf ${MODULES_PATH}/${module}/*.tfvars ${MODULES_PATH}/${module}/plan.out ${MODULES_PATH}/${module}/.terraform
	else
            echo "Exiting script"
	    rm -rf ${MODULES_PATH}/${module}/*.tfvars ${MODULES_PATH}/${module}/plan.out ${MODULES_PATH}/${module}/.terraform
	    exit 0
	fi

	cd -
    done
}

runAnsible() {
    if [[ ${ACTION} == "destroy" ]]
    then
        exit 0
    fi

    ANSIBLE_PATH="${BASEDIR}/ansible"
    PRIVATE_KEY_FILENAME="devops-exam-ton-tiosso.pem"

    cd ${ANSIBLE_PATH}

    echo "Running Ansible..."
    ansible-playbook -i inventory -b main.yml

    cd -

    echo "Run: curl -k -H 'Host: devops-exam-ton-tiosso.com' https://${EC2_PUBLIC_IP}"
}

cleanupS3() {
    if [[ ${ACTION} == "destroy" ]]
    then
        rm -rf ${MODULES_PATH}/s3-backend/*.tfstate*
    fi
}

export AWS_ACCESS_KEY=${ACCESS_KEY}
export AWS_SECRET_KEY=${SECRET_KEY}
execTerraform
runAnsible
cleanupS3
