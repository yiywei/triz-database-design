CREATE TABLE parameter (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE principle (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE contradiction (
    id CHAR(36) PRIMARY KEY,
    improving_parameter_id CHAR(36) NOT NULL,
    worsening_parameter_id CHAR(36) NOT NULL,
    FOREIGN KEY (improving_parameter_id) REFERENCES parameter(id),
    FOREIGN KEY (worsening_parameter_id) REFERENCES parameter(id)
);

CREATE TABLE patent (
    id CHAR(36) PRIMARY KEY,
    title VARCHAR(255),
    number VARCHAR(100),
    filename VARCHAR(100),
    status VARCHAR(100),
    publish_date DATE,
    upload_date DATETIME,
    rawtext LONGTEXT,
    abstract LONGTEXT,
    inventor VARCHAR(255),
    law_firm_names VARCHAR(255),
    assignee_names VARCHAR(255),
    classification_codes VARCHAR(255),
    keywords LONGTEXT,
    is_prior_art TINYINT,
    is_competitor TINYINT
);

CREATE TABLE patent_analysis (
    id CHAR(36) PRIMARY KEY,
    patent_id CHAR(36) NOT NULL,
    contradiction_id CHAR(36),
    principle_id CHAR(36),
    confidence_score DECIMAL(5, 2),
    review_status VARCHAR(255),
    extraction_version VARCHAR(100),
    analysis_date DATETIME,
    user_feedback LONGTEXT,
    feedback_date DATETIME,
    FOREIGN KEY (patent_id) REFERENCES patent(id),
    FOREIGN KEY (contradiction_id) REFERENCES contradiction(id),
    FOREIGN KEY (principle_id) REFERENCES principle(id)
);

CREATE TABLE patent_citation (
    id CHAR(36) PRIMARY KEY,
    patent_id CHAR(36) NOT NULL,
    cited_patent_number VARCHAR(255),
    citation_context LONGTEXT,
    citation_type VARCHAR(255),
    citation_date DATE,
    FOREIGN KEY (patent_id) REFERENCES patent(id)
);

CREATE TABLE matrix_contradiction (
    id CHAR(36) PRIMARY KEY,
    improving_parameter_id CHAR(36) NOT NULL,
    worsening_parameter_id CHAR(36) NOT NULL,
    FOREIGN KEY (improving_parameter_id) REFERENCES parameter(id),
    FOREIGN KEY (worsening_parameter_id) REFERENCES parameter(id)
);

CREATE TABLE matrix_contradiction_principle(
	matrix_contradiction_id CHAR(36),
    principle_id CHAR(36),
    FOREIGN KEY (matrix_contradiction_id) REFERENCES matrix_contradiction(id),
    FOREIGN KEY (principle_id) REFERENCES principle(id)
)

LOAD DATA INFILE '/triz_data/TRIZ_parameters.csv'
INTO TABLE parameter
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/triz_data/TRIZ_contradictions.csv'
INTO TABLE contradiction
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/triz_data/TRIZ_principles.csv'
INTO TABLE principle
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;