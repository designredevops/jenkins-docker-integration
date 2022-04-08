pipeline {
   agent any

   environment {

      jdk17Home     = tool name: 'JDK17'
      dockerHome    = tool 'DOCKER'
      mavenHome     = tool 'MAVEN'
      TAG      = sh(script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true)

      PATH = "$dockerHome/bin:$mavenHome/bin:$jdk17Home/bin:$PATH"
   }

   stages{

      stage('Compile') {
         steps{

	    script {
              TAG           = sh(script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true)
              IMAGE         = "designre/webapp:$TAG"
            }

            sh "mvn clean compile"
         }
      }

      stage('Test') {
         steps{
            sh "mvn test"
         }
      }

      stage('Integration Test') {
         steps{
            sh "mvn failsafe:integration-test failsafe:verify"
         }
      }

      stage('Package') {
         steps{
            script{
               sh "mvn package -DskipTests"
            }
         }
      }

      stage('Build Docker Image') {
                  steps{
                      script{
                          dockerImage = docker.build("${IMAGE}")
                      }
                  }
      }

      stage('Push Docker Image') {
                  steps{
                      script{
                          docker.withRegistry('','docker-hub'){
                              dockerImage.push()
                              dockerImage.push('latest')
                          }
                      }
                  }
      }
   }
}