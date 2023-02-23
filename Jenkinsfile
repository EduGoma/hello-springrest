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
        sh './gradlew test'
      }        
      post{
        always{
          junit allowEmptyResults: true, keepLongStdio: true, testResults: 'build/test-results/test/*xml'
        }
      }        
    }
    stage('Test Jacoco') {
      steps {
        sh './gradlew clean test jacocoTestReport'
        jacoco() 
      }
    }
    stage('Publish Html') {
      steps {
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, includes: '**/jacoco/html/**', keepAll: false, reportDir: 'build/reports/jacoco/', reportFiles: 'index.html', reportName: 'jacocoReport'])
      }
    }
    stage('Package image'){
      steps{
        withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
            sh "echo $CR_PAT | docker login ghcr.io -u edugoma --password-stdin"
            sh 'docker-compose push'
            sh "docker push ghcr.io/edugoma/hello-springrest:1.0.${BUILD_NUMBER}"
        }
      }
    }
    stage('Deploy to Elastic Beanstalk') {
      steps {
        withAWS(credentials: 'AWS-credential', region: 'eu-west-1') {
          dir('./elasticfolder') {
			      sh 'eb deploy hello-eb2 --environment hello-eb2-dev'
          }   
        }
      }
    }  
  }
}
