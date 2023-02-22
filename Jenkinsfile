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
          withCredentials([file(credentialsId: 'config-boints-prod', variable: 'KUBECONFIG')]) {
            sh 'kubectl cluster-info'
          }
        }
      }
    }
  
  }
}



