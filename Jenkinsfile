pipeline {
  options {
    ansiColor('gnome-terminal')
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
            sh 'sed -i "s/GODADDY_KEY/${GODADDY_KEY}/" main.tf'
            sh 'sed -i "s/GODADDY_SECRET/${GODADDY_SECRET}/" main.tf'
            sh 'cat main.tf'
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
            sh 'terraform apply --auto-approve'
          }
        }
      }
    }
    stage('Show') {     
      steps {
        container('kubectl') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-winmoney-stage', variable: 'KUBECONFIG')]) {
            sh 'terraform show'
          }
        }
      }
    }
  }
}
