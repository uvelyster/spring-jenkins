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
		label 'gradle'
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
		label 'gradle'
	    }
	  } 
          steps {
              unstash 'build-artifact'
              sh 'docker build -t myregistry.com/root/demo/app .'
              
          }
        }
        stage('deploy'){
	  agent{
	    node{
		label 'gradle'
	    }
	  } 
          steps {
            sh 'echo ${BUILD_NUMBER}'
          }
        }
  }
}

