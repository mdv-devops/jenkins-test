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
//          withCredentials([file(credentialsId: 'config-boints-prod', variable: 'KUBECONFIG')])
          withCredentials([[
          credentialsId: 'aws-credentials',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]])
          {
            sh 'aws s3 ls'
          }
        }
      }
    }
  
  }
}



