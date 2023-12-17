pipeline{
    agent any
    
    stages{
        stage('checkout') {
            steps{
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'cred-RR', url: 'https://github.com/RohitDevOpsCloud/sample-app.git']])
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
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubeconfig', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                    
                    sh "kubectl apply -f my-app.yaml"
                    }
                }
            }
        }
    
    }
}
