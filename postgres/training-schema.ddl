create schema training;

alter schema training owner to postgres;

create table if not exists application
(
	id integer not null
		constraint application_pkey
			primary key,
	name varchar(255) not null,
	url varchar(255) not null
);

alter table application owner to postgres;

create table if not exists department
(
	id integer not null
		constraint department_pkey
			primary key,
	name varchar(255) not null,
	description varchar(255),
	display_order integer default 0 not null
);

alter table department owner to postgres;

create table if not exists role
(
	id integer not null
		constraint role_pkey
			primary key,
	name varchar(255) not null,
	level integer not null
);

alter table role owner to postgres;

create table if not exists app_menu_item
(
	id integer not null
		constraint "app-menu-item_pkey"
			primary key,
	name varchar(255) not null,
	url varchar(255) not null,
	level integer not null,
	app_id integer not null
		constraint fk_app_id
			references application,
	tooltip varchar(255)
);

alter table app_menu_item owner to postgres;

create table if not exists dept_role
(
	id integer not null
		constraint "dept-role_pkey"
			primary key,
	dept_id integer not null
		constraint fk_dept_id
			references department,
	role_id integer not null
		constraint fk_role_id
			references role
);

alter table dept_role owner to postgres;

create table if not exists dept_role_application
(
	id integer not null
		constraint "dept-role-application_pkey"
			primary key,
	dept_role_id integer not null
		constraint fk_dept_role_id
			references dept_role,
	app_id integer not null
		constraint fk_app_id
			references application
);

alter table dept_role_application owner to postgres;


CREATE TABLE training.qa_user
(
    id integer NOT NULL,
    user_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    reviewer_id integer,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT qa_user_pkey PRIMARY KEY (id),
    CONSTRAINT fk_user_id FOREIGN KEY (reviewer_id)
        REFERENCES training.qa_user (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.qa_user
    OWNER to postgres;


CREATE TABLE training.qa_user_self_reflection_form
(
    id integer NOT NULL,
    qa_user_id integer NOT NULL,
    strengths_text character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    weaknesses_text character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    opportunities_text character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    threats_text character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    week_commencing date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT qa_user_self_reflection_form_pkey PRIMARY KEY (id),
    CONSTRAINT fk_qa_user_id FOREIGN KEY (qa_user_id)
        REFERENCES training.qa_user (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.qa_user_self_reflection_form
    OWNER to postgres;


CREATE TABLE training.qa_user_self_reflection_form_status
(
    id integer NOT NULL,
    qa_user_self_reflection_form_id integer NOT NULL,
    self_reflection_status_id integer NOT NULL,
    qa_user_id integer NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT qa_user_self_reflection_form_status_pkey PRIMARY KEY (id),
    CONSTRAINT fk_qa_user_id FOREIGN KEY (qa_user_id)
        REFERENCES training.qa_user (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_qa_user_self_reflection_form_id FOREIGN KEY (qa_user_self_reflection_form_id)
        REFERENCES training.qa_user_self_reflection_form (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_self_reflection_status_id FOREIGN KEY (self_reflection_status_id)
        REFERENCES training.self_reflection_status (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.qa_user_self_reflection_form_status
    OWNER to postgres;

CREATE TABLE training.self_rating
(
    id integer NOT NULL,
    self_rating_question_id integer NOT NULL,
    qa_user_self_reflection_form_id integer NOT NULL,
    selected_rating character varying(255) COLLATE pg_catalog."default" NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT self_rating_pkey PRIMARY KEY (id),
    CONSTRAINT fk_qa_user_self_reflection_form_id FOREIGN KEY (qa_user_self_reflection_form_id)
        REFERENCES training.qa_user_self_reflection_form (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_self_rating_question_id FOREIGN KEY (self_rating_question_id)
        REFERENCES training.self_rating_question (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.self_rating
    OWNER to postgres;


CREATE TABLE training.self_rating_question
(
    id integer NOT NULL,
    question_text character varying(255) COLLATE pg_catalog."default" NOT NULL,
    num_options integer NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT self_rating_question_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.self_rating_question
    OWNER to postgres;


CREATE TABLE training.self_reflection_review
(
    id integer NOT NULL,
    qa_user_id integer NOT NULL,
    qa_user_self_reflection_form_id integer NOT NULL,
    trainer_comments character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    learning_pathway character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT self_reflection_review_pkey PRIMARY KEY (id),
    CONSTRAINT fk_qa_user_id FOREIGN KEY (qa_user_id)
        REFERENCES training.qa_user (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_qa_user_self_reflection_form_id FOREIGN KEY (qa_user_self_reflection_form_id)
        REFERENCES training.qa_user_self_reflection_form (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.self_reflection_review
    OWNER to postgres;


CREATE TABLE training.self_reflection_status
(
    id integer NOT NULL,
    status_text character varying(255) COLLATE pg_catalog."default" NOT NULL,
    last_updated_timestamp timestamp without time zone NOT NULL,
    last_updated_by character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT self_reflection_status_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE training.self_reflection_status
    OWNER to postgres;
