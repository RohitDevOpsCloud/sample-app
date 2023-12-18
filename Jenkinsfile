pipeline {
    agent any

    parameters {
        string(name: 'EKS_CLUSTER_NAME', defaultValue: 'RR-cluster', description: 'Enter the desired EKS cluster name')
        string(name: 'NODE_GROUP_NAME', defaultValue: 'cluster_NG', description: 'Enter the desired node group name')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'Enter the desired AWS region')
        credentials(name: 'AWS_CREDENTIALS', description: 'AWS credentials with EKS permissions', defaultValue: 'aws-cred', required: true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'cred-RR', url: 'https://github.com/RohitDevOpsCloud/sample-app.git']])

            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    dir('terraformeks'){
                        withCredentials([usernamePassword(credentialsId: 'aws-cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                            sh 'terraform init'
                        }
                }   }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('terraformeks') {
                        withCredentials([usernamePassword(credentialsId: 'aws-cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                            sh "terraform apply -var 'eks_cluster_name=${params.EKS_CLUSTER_NAME}' -var 'node_group_name=${params.NODE_GROUP_NAME}' -var 'aws_region=${params.AWS_REGION}' -auto-approve"
                        }  
                    }
                }    
                    
            }
        }

        stage('Update Kubeconfig') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                        
                        sh "aws eks update-kubeconfig --name ${params.EKS_CLUSTER_NAME} --region ${params.AWS_REGION}"
                        sh "mv ${JENKINS_HOME}/.kube/config ${WORKSPACE}/kubeconfig"
                        
                    }    
                }
            }
        }
        
        stage('build and push') {
            steps{
                script {
                    
                    sh "docker build -t rohitkas/sample-app ."
                    withCredentials([string(credentialsId: 'docker-cred', variable: 'DOCKER_PASS')]) {
                    sh "docker login -u rohitkas -p ${DOCKER_PASS}"
                    
                    sh "docker push rohitkas/sample-app"
                    }
                }
                
            }
        }
        
        stage('Deploy to eks') {
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'aws-cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                        sh "kubectl apply -f my-app.yaml  --kubeconfig=${WORKSPACE}/kubeconfig"
                    }
                    
                }
            }
        }

    }
}
