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
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'), file(credentialsId: 'config-boints-prod', variable: 'KUBECONFIG')]) {
            sh 'kubectl create ns test-jenkins'
          }
        }
      }
    }
  }
}