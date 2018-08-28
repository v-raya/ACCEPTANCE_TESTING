# frozen_string_literal: true

module PersonHelpers
  ROLES = ['Victim', 'Mandated Reporter', 'Non-mandated Reporter',
           'Anonymous Reporter'].freeze

  RACES = {
    'White' => ['Armenian', 'Central American',
                'European', 'Middle Eastern',
                'Romanian'],
    'Black or African American' => %w[Black Ethiopian Caribbean],
    'Asian' => ['Asian Indian', 'Cambodian', 'Chinese', 'Filipino', 'Hmong',
                'Japanese', 'Korean', 'Laotion', 'Other Asian', 'Vietnamese'],
    'American Indian or Alaska Native' => ['American Indian', 'Alaska Native'],
    'Native Hawaiian or Other Pacific Islander' => ['Guamanian', 'Hawaiian',
                                                    'Other Asian/Pacific Islander',
                                                    'Other Pacific Islander',
                                                    'Polynesian',
                                                    'Samoan']
  }.freeze

  UNKNOWN_RACE = ['Unknown', 'Abandoned', 'Declined to answer'].freeze

  HISPANIC_LATINO_ORIGIN = {
    'Yes' => ['Hispanic', 'Mexican', 'Central American', 'South American'],
    'No' => []
  }.freeze

  LANGUAGES = ['American Sign Language', 'Arabic', 'Armenian', 'Cambodian',
               'Cantonese', 'English', 'Farsi', 'German', 'Hawaiian', 'Hebrew',
               'Hmong', 'Ilocano', 'Indochinese', 'Italian', 'Japanese',
               'Korean', 'Mandarin', 'Mien', 'Other Chinese', 'Other Non-English',
               'Polish', 'Portuguese', 'Romanian', 'Russian', 'Samoan',
               'Sign Language (Not ASL)', 'Spanish', 'Tagalog', 'Thai',
               'Turkish', 'Vietnamese'].freeze

  SEX_AT_BIRTH = %w[Male Female Intersex Unknown].freeze

  APPROXIMATE_AGE = %w[Days Weeks Months Years].freeze

  SUFFIX = %w[Esq Jr Sr MD PhD JD].freeze

  SELECT_FIELDS = {
    suffix: 'Suffix',
    approximate_age_units: 'approximate_age_units',
    gender: 'Sex at Birth'
  }.freeze

  MULTI_SELECT_FIELDS = {
    role: 'Role',
    languages: 'Language(s) (Primary First)'
  }.freeze

  CHECKBOX_FIELDS = {
    race: 'Race',
    ethnicity: 'Hispanic/Latino Origin'
  }.freeze

  INPUT_FIELDS = {
    first_name: 'First Name',
    middle_name: 'Middle Name',
    last_name: 'Last Name',
    ssn: 'Social security number',
    date_of_birth_input: 'Date of birth',
    approximate_age: 'Approximate Age'
  }.freeze

  def default_values(**args)
    {
      first_name: first_name, middle_name: middle_name,
      last_name: last_name, ssn: ssn, suffix: suffix,
      date_of_birth_input: date_of_birth, role: role,
      gender: args.fetch(:gender, SEX_AT_BIRTH.sample),
      race: args.fetch(:races, RACES.keys.sample),
      ethnicity: args.fetch(:ethnicity, HISPANIC_LATINO_ORIGIN.keys.sample),
      languages: args.fetch(:languages, LANGUAGES.sample(2))
    }
  end

  def approximate_age(**args)
    {
      approximate_age: rand(1..10),
      approximate_age_units: args.fetch(:approximate_age_units, APPROXIMATE_AGE.sample),
    }
  end
end
