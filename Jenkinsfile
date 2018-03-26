def notifyBuild(String buildStatus, Exception e) {
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = """*${buildStatus}*: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':\nMore detail in console output at <${env.BUILD_URL}|${env.BUILD_URL}>"""
  def details = """${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':\n
    Check console output at ${env.BUILD_URL} """
  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
    details +="<p>Error message ${e.message}, stacktrace: ${e}</p>"
    summary +="\nError message ${e.message}, stacktrace: ${e}"
  }
}

node ('intake-slave') {
   properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')),
              [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
			  parameters([
			  string(defaultValue: 'smoke', description: '', name: 'FEATURE_SET'),
			  string(defaultValue: 'https://web.preint.cwds.io', description: '', name: 'APP_URL')]),pipelineTriggers([])])

   def errorcode = null;
   def buildInfo = '';

 try {

   stage('Preparation') {
		  cleanWs()
		  git branch: 'master', credentialsId: '433ac100-b3c2-4519-b4d6-207c029a103b', url: 'git@github.com:ca-cwds/acceptance_testing.git'
   }
   stage('Build Docker'){
        sh 'docker-compose build'
		//withDockerRegistry([credentialsId: '6ba8d05c-ca13-4818-8329-15d41a089ec0']) {
			//sh "docker tag cwds/acceptance_testing cwds/acceptance_testing:${version}"
			//sh "docker push cwds/acceptance_testing cwds/acceptance_testing:${version}"
		//}
	 }
   //stage('Run tests webkit'){
  // withEnv(["APP_URL=${APP_URL}",
  //           "FEATURE_SET=${FEATURE_SET}",
  //           "CAPYBARA_DRIVER=webkit"]) {
  //            sh 'docker-compose run acceptance_test'
  //} 
	//}
   stage('Run tests selenium'){
      withEnv(["APP_URL=${APP_URL}",
               "FEATURE_SET=${FEATURE_SET}",
               "CAPYBARA_DRIVER=${CAPYBARA_DRIVER}"]) {
                sh 'docker-compose run acceptance_test'
      }
	  }	
 } catch (Exception e)    {
	   errorcode = e
	   currentBuild.result = "FAIL"
	   notifyBuild(currentBuild.result,errorcode)
	}
	finally {
	     fingerprint 'reports/*'
	     junit allowEmptyResults: true, testResults: 'reports/TEST-*.xml'
	}
}
