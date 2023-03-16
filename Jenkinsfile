pipeline{
  agent none
  stages{
    stage('gradle build'){
      agent{
        node{
          label 'gradle'
	}
      } 
      steps {
        sh 'gradle build -x test'
        stash(name: 'build-artifact', includes: 'build/libs/*.jar')
      }
    }
    stage('upload to artifactory'){
      agent{
        node{
          label 'built-in'
	}
      }
      steps {
        script {
          unstash 'build-artifact'
          def server = Artifactory.server 'Artifactory'
          def uploadSpec = """{
          "files": [
            {
              "pattern": "build/libs/*.jar",
              "target": "example-repo-local/${BRANCH_NAME}/${BUILD_NUMBER}/"
            }
          ]
        }"""
        server.upload(uploadSpec)
        }
      }
    }
    stage('download and build container image'){
	    agent{
	     node{
		    label 'built-in'
	      }
	    } 
      steps {
        unstash 'build-artifact'
        script {
          myapp = docker.build("myregistry.com/root/spring-music/myapp:${env.BUILD_ID}")
        }
      }
    }
    stage('push'){
	    agent{
	      node{
		      label 'built-in'
	      }
	    } 
      steps {
        script {
          docker.withRegistry('https://myregistry.com', 'gitlab_login') {
            myapp.push("latest")
            myapp.push("${env.BUILD_ID}")
          }
        }
      }
    }
    stage('deploy'){
	    agent{
	      node{
		      label 'built-in'
	      }
      }
      steps{
        sh 'kubectl apply -f deploy-app.yml'
      }
    }
  }
}

