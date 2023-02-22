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
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]]) {
            sh 'echo "test"'
          }
        }
//        container('kubectl') {
//          withCredentials([file(credentialsId: 'config-boints-prod', variable: 'KUBECONFIG')]) {
//            sh 'kubectl cluster-info'
//          }
//        }
      }
    }
  }
}



