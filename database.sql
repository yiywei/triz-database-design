CREATE TABLE patent (
    patent_id INT PRIMARY KEY,
    patent_title VARCHAR(255),
    patent_number VARCHAR(100),
    patent_filename VARCHAR(100),
    patent_status VARCHAR(100),
    patent_publish_date DATETIME,
    patent_upload_date DATETIME,
    patent_rawtext LONGTEXT,
    patent_abstract LONGTEXT,
    patent_inventor VARCHAR(255),
    law_firm_names VARCHAR(255),
    assignee_names VARCHAR(255),
    classification_codes VARCHAR(255),
    keywords LONGTEXT,
    is_prior_art TINYINT(1),
    is_competitor TINYINT(1)
);

CREATE TABLE patent_analysis (
    analysis_id INT PRIMARY KEY,
    patent_id INT NOT NULL,
    contradiction_id INT,
    principle_id INT,
    confidence_score DECIMAL(5, 2),
    review_status VARCHAR(255),
    extraction_version VARCHAR(100),
    analysis_date DATETIME,
    user_feedback LONGTEXT,
    feedback_date DATETIME,
    FOREIGN KEY (patent_id) REFERENCES patent(patent_id),
    FOREIGN KEY (contradiction_id) REFERENCES contradictions(contradiction_id),
    FOREIGN KEY (principle_id) REFERENCES principles(principle_id)
);

CREATE TABLE LLM_suggestion (
    suggestion_id INT PRIMARY KEY,
    principle_id INT NOT NULL,
    contradiction_id INT NOT NULL,
    FOREIGN KEY (principle_id) REFERENCES principles(principle_id),
    FOREIGN KEY (contradiction_id) REFERENCES contradictions(contradiction_id)
);

CREATE TABLE patent_citation (
    citation_id INT PRIMARY KEY,
    patent_id INT NOT NULL,
    cited_patent_number VARCHAR(255),
    citation_context LONGTEXT,
    citation_type VARCHAR(255),
    citation_date DATETIME,
    FOREIGN KEY (patent_id) REFERENCES patent(patent_id)
);

CREATE TABLE contradictions (
    contradiction_id INT PRIMARY KEY,
    improving INT NOT NULL,
    worsening INT NOT NULL,
    FOREIGN KEY (improving) REFERENCES parameters(parameter_id),
    FOREIGN KEY (worsening) REFERENCES parameters(parameter_id)
);

CREATE TABLE parameters (
    parameter_id INT PRIMARY KEY,
    parameter_name VARCHAR(255)
);

CREATE TABLE principles (
    principle_id INT PRIMARY KEY,
    principle_name VARCHAR(255)
);

CREATE TABLE triz_matrix (
    matrix_id INT PRIMARY KEY,
    contradiction_id INT NOT NULL,
    principle_id INT NOT NULL,
    FOREIGN KEY (contradiction_id) REFERENCES contradictions(contradiction_id),
    FOREIGN KEY (principle_id) REFERENCES principles(principle_id)
);

LOAD DATA INFILE '/triz_data/TRIZ_parameters.csv'
INTO TABLE parameters
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/triz_data/TRIZ_contradictions.csv'
INTO TABLE contradictions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/triz_data/TRIZ_principles.csv'
INTO TABLE principles
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;