node('Slave') {
    checkout scm

    try {
        stage('Test') {
            sh 'make test'
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
