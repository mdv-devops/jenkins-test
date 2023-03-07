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
            ansiColor('xterm') {
              sh 'kubectl get ns'
            }
          }
        }
      }
    }
    stage('Init') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG'), gitUsernamePassword(credentialsId: 'GitHub', gitToolName: 'Default')]) {
            ansiColor('xterm') {
              sh 'terraform init'
            }
          }
        }
      }
    }
    stage('Plan') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            ansiColor('xterm') {
              sh 'terraform plan'
            }
          }
        }
      }
    }
    stage('Apply') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            ansiColor('xterm') {
              sh 'terraform apply --auto-approve'
            }
          }
        }
      }
    }
    stage('Show') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            ansiColor('xterm') {
              sh 'terraform show'
            }
          }
        }
      }
    }
  }
  currentBuild.result = 'SUCCESS'
}
