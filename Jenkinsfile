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
          withCredentials([file(credentialsId: 'config-boints-prod', variable: 'KUBECONFIG')])
          withAWS(credentials: 'aws-credentials')
          {
            sh 'kubectl cluster-info'
          }
        }
      }
    }
  
  }
}



