# frozen_string_literal: true

DEFAULT_SUPERVISIOR = {
  "user": 'RACFID',
  "staffId": '0X5',
  "roles": ['CWS-admin', 'Supervisor'],
  "county_code": '56',
  "county_cws_code": '1123',
  "county_name": 'Ventura',
  "privileges": ['CWS Case Management System', 'Resource Management',
                 'Resource Mgmt Placement Facility Maint', 'Sealed',
                 'Snapshot-rollout', 'Hotline-rollout',
                 'Facility-search-rollout', 'RFA-rollout',
                 'development-not-in-use']
}.freeze

SOCIAL_WORKER_ONLY = {
  "user": "BRADYG",
  "staffId": "aaw",
  "roles": [
    "SocialWorker"
  ],
  "county_code": "17",
  "county_cws_code": "1084",
  "county_name": "Lake",
  "privileges": [
    "CWS Case Management System"
  ]
}.freeze

COUNTY_SOCIAL_WORKER_ONLY = {
  "user": 'BRADYG',
  "staffId": 'aaw',
  "roles": ['SocialWorker'],
  "county_code": '17',
  "county_cws_code": '1084',
  "county_name": 'Lake',
  "privileges": ['CWS Case Management System']
}.freeze

COUNTY_SENSITIVE_SOCIAL_WORKER = {
  "user": 'BRADYP',
  "staffId": 'aax',
  "roles": [
    'SocialWorker'
  ],
  "county_code": '17',
  "county_cws_code": '1084',
  "county_name": 'Lake',
  "privileges": [
    'CWS Case Management System',
    'Sensitive Persons'

  ]
}.freeze

COUNTY_SEALED_SOCIAL_WORKER = {
  "user": 'CLUSTR',
  "staffId": '0UX',
  "roles": [
    'SocialWorker'
  ],
  "county_code": '34',
  "county_cws_code": '1101',
  "county_name": 'Sacramento',
  "privileges": [
    'CWS Case Management System',
    'Sealed'
  ]
}.freeze

STATE_SENSITIVE_SOCIAL_WORKER = {
  "user": 'TESTIE',
  "staffId": '0RG',
  "roles": [
    'Supervisor'
  ],
  "county_code": '99',
  "county_cws_code": '1126',
  "county_name": 'State of California',
  "privileges": [
    'Sensitive Persons'
  ]
}.freeze

STATE_SEALED_SOCIAL_WORKER = {
  "user": 'BURNSM',
  "staffId": '0MJ',
  "roles": [
    'SocialWorker'
  ],
  "county_code": '99',
  "county_cws_code": '1126',
  "county_name": 'State of California',
  "privileges": [
    'Sealed',
    'CWS Case Management System'
  ]
}.freeze
