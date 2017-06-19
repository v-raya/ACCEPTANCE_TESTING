node('Slave') {
    checkout scm

    try {
        stage('Test') {
            withEnv(["TEST_TARGET_URL=${TEST_TARGET_URL}",
                     "DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_FILE}"],
                     "FEATURE_SET=${FEATURE_SET}") {
                sh 'make test'
            }
        }
    }
    finally {
        try {
            stage ('Reports') {
                step([$class: 'JUnitResultArchiver', testResults: '**/reports/*.xml'])
            }
        }
        catch(e) {
            currentBuild.result = 'FAILURE'
        }

        stage('Clean') {
            retry(2) {
                sh 'make clean'
            }
        }
    }
}
