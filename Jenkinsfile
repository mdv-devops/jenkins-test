String credentialsId = 'aws-credentials'
pipeline {
  options {
    ansiColor('xterm')
  }

  agent {
    kubernetes {
      yamlFile 'builder.yaml'
    }
  }

  stages {

    stage('Check connections') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            sh 'kubectl get ns'
          }
        }
      }
    }
    stage('Init') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG'), gitUsernamePassword(credentialsId: 'GitHub', gitToolName: 'Default')]) {
            sh 'terraform init'
          }
        }
      }
    }
    stage('Plan') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            sh 'terraform plan'
          }
        }
      }
    }
    stage('Apply') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            sh 'terraform destroy --auto-approve'
          }
        }
      }
    }
  }
}
