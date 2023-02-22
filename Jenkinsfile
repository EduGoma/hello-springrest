pipeline {
  agent any
  options {
    ansiColor('css')
    timestamps()
   }
  stages{
    stage('Build images') {
      steps {
        sh 'docker-compose build'
        sh "git tag 1.0.${BUILD_NUMBER}" 
        sh "docker tag ghcr.io/edugoma/hello-springrest:latest ghcr.io/edugoma/hello-springrest:1.0.${BUILD_NUMBER}" 
        sshagent(['Git-hubSSH']) {
          sh "git push --tags"
        }
      }
    }
    stage('Test'){
      steps{        
        junit allowEmptyResults: true, keepLongStdio: true, testResults: 'build/test-results/test/*xml'
      }        
    }
    stage('Package'){
      steps{
        withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
            sh "echo $CR_PAT | docker login ghcr.io -u edugoma --password-stdin"
            sh 'docker-compose push'
            sh "docker push ghcr.io/edugoma/hello-springrest:1.0.${BUILD_NUMBER}"
        }
      }
    }
    stage('Deploy changes'){
      steps{
        withAWS(credentials: 'AWS-credential') {
          sh "cd eb"
          sh "eb deploy hello-eb2-dev"
        }
      }
    }
  }   
}
