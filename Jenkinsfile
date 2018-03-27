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

node ('preint') {
   properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')),
              [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
			  parameters([
			  string(defaultValue: 'xvfb_firefox', description: 'Name of the capybara driver, options include: webkit, xvfb_firefox', name: 'CAPYBARA_DRIVER'),
			  string(defaultValue: 'smoke', description: 'The set of tests, each set can be found in feature_set.yml', name: 'FEATURE_SET'),
			  string(defaultValue: 'https://web.preint.cwds.io', description: 'Target URL to run the tests', name: 'APP_URL')]),pipelineTriggers([])])

   def errorcode = null;
   def buildInfo = '';

 try {
   stage('Checkout latest version') {
		  cleanWs()
		  git branch: 'master', credentialsId: '433ac100-b3c2-4519-b4d6-207c029a103b', url: 'git@github.com:ca-cwds/acceptance_testing.git'
   }

   stage('Build Docker'){
        sh 'docker-compose build'
	 }

   stage('Run tests'){
      withEnv(["APP_URL=${APP_URL}",
               "FEATURE_SET=${FEATURE_SET}",
               "CAPYBARA_DRIVER=${CAPYBARA_DRIVER}"]) {
                sh 'docker-compose run acceptance_test'
      }
	  }

    stage ('Integration Env Deploy') {
               build job: '/Integration Environment/deploy-intake-app/',
                   parameters: [
                   string(name: 'INTAKE_APP_VERSION', value: "latest"),
                   string(name: 'inventory', value: 'inventories/integration/hosts.yml')
                   ],
                   wait: false
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
