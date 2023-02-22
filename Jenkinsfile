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

    stage('Kaniko Build & Push "its-shark-time" Image') {
      steps {
        container('kaniko') {
          script {
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \
                             --destination=max3014/its-shark-time:v-${BUILD_NUMBER} \
                             --destination=max3014/its-shark-time:latest
            '''
          }
        }
      }
    }

    stage('Deploy App to Kubernetes') {     
      steps {
        container('kubectl') {
          withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh 'sed -i "s/latest/v-${BUILD_NUMBER}/" yaml/deployment.yaml'
            sh 'cat yaml/deployment.yaml'
            sh 'kubectl apply -f yaml/deployment.yaml'
          }
        }
      }
    }
  
  }
}



