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
