import java.text.SimpleDateFormat

node('intake-slave') {
  properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10')),
      [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
      parameters([
        string(defaultValue: 'cwds/intake:1.1.174', description: 'Intake container version', name: 'INTAKE_IMAGE_VERSION'),
        string(defaultValue: 'cwds/intake_api_prototype:latest', description: 'Intake Api container version', name: 'INTAKE_API_IMAGE_VERSION'),
        string(defaultValue: 'cwds/postgresql_data:0.5.8-SNAPSHOT', description: 'Postgres container version', name: 'POSTGRES_IMAGE_VERSION'),
        string(defaultValue: 'cwds/dora:1.5.7_1989-RC', description: 'Dora container version', name: 'DORA_IMAGE_VERSION'),
        string(defaultValue: 'cwds/api:0.6.2.312', description: 'Ferb container version', name: 'FERB_IMAGE_VERSION'),
        string(defaultValue: 'cwds/elasticsearch_xpack_data:1.5.7-SNAPSHOT', description: 'ElasticSearch container version', name: 'ELASTICSEARCH_IMAGE_VERSION'),
        string(defaultValue: 'cwds/perry:1.6.2_424-RC', description: 'Perry container version', name: 'PERRY_IMAGE_VERSION'),
        string(defaultValue: 'cwds/db2data:0.5.6-SNAPSHOT', description: 'DB2 Data container version', name: 'DB2DATA_IMAGE_VERSION')
    ])
  ])

  checkout scm
  def curStage = 'Start'
  def pipelineStatus = 'SUCCESS'
  def successColor = '11AB1B'
  def failureColor = '#FF0000'
  SimpleDateFormat dateFormatGmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  def buildDate = dateFormatGmt.format(new Date())
  def docker_credentials_id = '6ba8d05c-ca13-4818-8329-15d41a089ec0'

  try {

    stage('Fetch testing bubble'){
      dir('bubble'){
        git branch: 'FIT-50-create-intake-acceptance-pipeline', credentialsId: '433ac100-b3c2-4519-b4d6-207c029a103b', url: 'git@github.com:ca-cwds/integrated-test-environment.git'
      }
    }

    stage('Run acceptance tests'){
      withDockerRegistry([credentialsId: docker_credentials_id]){
        withEnv(["ACCEPTANCE_BUILD_PATH=../", "INTAKE_IMAGE_VERSION=${INTAKE_IMAGE_VERSION}",
                "POSTGRES_IMAGE_VERSION=${POSTGRES_IMAGE_VERSION}", "DORA_IMAGE_VERSION=${DORA_IMAGE_VERSION}",
                "FERB_IMAGE_VERSION=${FERB_IMAGE_VERSION}", "ELASTICSEARCH_IMAGE_VERSION=${ELASTICSEARCH_IMAGE_VERSION}",
                "ELASTICSEARCH_IMAGE_VERSION=${ELASTICSEARCH_IMAGE_VERSION}", "PERRY_IMAGE_VERSION=${PERRY_IMAGE_VERSION}",
                "DB2DATA_IMAGE_VERSION=${DB2DATA_IMAGE_VERSION}"]) {
          sh './scripts/ci/acceptance_testing_run.rb'
        }
      }
    }
  } catch (e) {
    pipelineStatus = 'FAILED'
    currentBuild.result = 'FAILURE'
    throw e
  }

  finally {
    stage('Clean') {
      retry(2){
        dir('bubble'){
          echo '== Tearing down test bubble'
          sh "docker-compose -p acceptance_bubble_${BUILD_NUMBER} -f docker-compose.bubble.yml down --volumes --remove-orphans --rmi all"
        }
      }
      cleanWs()
    }
  }
}
