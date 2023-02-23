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
        sh "git tag 2.0.${BUILD_NUMBER}" 
        sh "docker tag ghcr.io/edugoma/hello-springrest:latest ghcr.io/edugoma/hello-springrest:2.0.${BUILD_NUMBER}" 
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
   stage('PMD Test') {
    steps {
     sh './gradlew pmdTest'
    }
    post {
     always {
      recordIssues(
       enabledForFailure: true,
       tool: pmdParser(pattern: 'build/reports/pmd/test.xml')
      )
      }
     }
    }
   stage('Trivy Test') {
    steps {
     sh "trivy fs --scanners vuln,secret,config -f json -o fsresults.json ."
     sh "trivy image -f json -o results.json 'ghcr.io/edugoma/hello-springrest:latest'"
    }
    post {
     always {
      recordIssues(tools: [trivy(pattern: '*.json')])
      }
     }
    }	  
/* Prueba de trivy en 2 pasos 
    stage('trivy Test file') {
     steps {
      sh "trivy fs --scanners vuln,secret,config -f json -o fsresults.json ."
      recordIssues(tools: [trivy(pattern: 'fsresults.json', id: 'trivy-file')])
     }      
    }
    stage('trivy Test image') {
     steps {
      sh "trivy image -f json -o results.json 'ghcr.io/edugoma/hello-springrest:latest'"
      recordIssues(tools: [trivy(pattern: 'results.json', id: 'trivy-image')])
     }      
    }*/
    stage('Package image'){
      steps{
        withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
            sh "echo $CR_PAT | docker login ghcr.io -u edugoma --password-stdin"
            sh 'docker-compose push'
            sh "docker push ghcr.io/edugoma/hello-springrest:2.0.${BUILD_NUMBER}"
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
