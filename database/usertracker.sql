/*
 * Remove foreign key constraints 1st to make dropping tables easier.
 */
alter table country_subdivisions
  drop foreign key fk_subdiv_cntry;

alter table notes
  drop foreign key fk_note_type;

alter table templates
  drop foreign key fk_temp_type;

alter table types
  drop foreign key fk_type_name;

alter table types
  drop foreign key fk_type_cat;

alter table url_templates
  drop foreign key fk_urltemp_site;

alter table url_templates
  drop foreign key fk_urltemp_temp;

alter table user_notes
  drop foreign key fk_unote_user;

alter table user_notes
  drop foreign key fk_unote_note;

alter table username_aliases
  drop foreign key fk_ualias_primary;

alter table username_aliases
  drop foreign key fk_ualias_alias;

alter table usernames
  drop foreign key fk_uname_user;

alter table usernames
  drop foreign key fk_uname_site;

alter table usernames
  drop foreign key fk_uname_type;

alter table usernames
  drop foreign key fk_uname_status;

alter table users
  drop foreign key fk_user_cntry;

alter table users
  drop foreign key fk_user_subdiv;

/*
 * Drop all update triggers.
 */
drop trigger if exists countries_update;
drop trigger if exists country_subdivisions_update;
drop trigger if exists notes_update;
drop trigger if exists sites_update;
drop trigger if exists statuses_update;
drop trigger if exists templates_update;
drop trigger if exists types_update;
drop trigger if exists types_categories_update;
drop trigger if exists types_names_update;
drop trigger if exists url_templates_update;
drop trigger if exists user_notes_update;
drop trigger if exists username_aliases_update;
drop trigger if exists usernames_update;
drop trigger if exists users_update;

/*
 * Drop all tables.
 */
drop table if exists countries;
drop table if exists country_subdivisions;
drop table if exists notes;
drop table if exists sites;
drop table if exists statuses;
drop table if exists templates;
drop table if exists types;
drop table if exists types_categories;
drop table if exists types_names;
drop table if exists url_templates;
drop table if exists user_notes;
drop table if exists username_aliases;
drop table if exists usernames;
drop table if exists users;

/*
 * Create tables (sans-foreign key constraints to not have to worry about ordering)
 */
create table countries (
  id int not null auto_increment,
  name varchar(128) default null,
  a2_code varchar(2) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table country_subdivisions (
  id int not null auto_increment,
  name varchar(128) default null,
  iso_code varchar(3) default null,
  country_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table notes (
  id int not null auto_increment,
  note varchar(1024) default null,
  type_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table sites (
  id int not null auto_increment,
  name varchar(128) default null,
  url varchar(128) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table statuses (
  id int not null auto_increment,
  name varchar(64) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table templates (
  id int not null auto_increment,
  type_id int default null,
  template varchar(128) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table types (
  id int not null auto_increment,
  name_id int default null,
  category_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table types_categories (
  id int not null auto_increment,
  category varchar(64) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table types_names (
  id int not null auto_increment,
  name varchar(64) default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table url_templates (
  site_id int default null,
  template_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00'
);

create table user_notes (
  user_id int default null,
  note_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00'
);

create table username_aliases (
  primary_username_id int default null,
  alias_username_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00'
);

create table usernames (
  id int not null auto_increment,
  username varchar(128) default null,
  user_id int default null,
  site_id int default null,
  type_id int default null,
  status_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

create table users (
  id int not null auto_increment,
  name varchar(64) default null,
  country_id int default null,
  subdivision_id int default null,
  created timestamp not null default current_timestamp,
  last_modified timestamp not null default '0000-00-00 00:00:00',
  primary key (id)
);

/*
 * Add foreign key constraints.
 */
alter table country_subdivisions
  add constraint fk_subdiv_cntry foreign key (country_id)
  references countries (id)
  on delete set null
  on update cascade;

alter table notes
  add constraint fk_note_type foreign key (type_id)
  references types (id)
  on delete set null
  on update cascade;

alter table templates
  add constraint fk_temp_type foreign key (type_id)
  references types (id)
  on delete set null
  on update cascade;

alter table types
  add constraint fk_type_name foreign key (name_id)
  references types_names (id)
  on delete set null
  on update cascade;

alter table types
  add constraint fk_type_cat foreign key (category_id)
  references types_categories (id)
  on delete set null
  on update cascade;

alter table url_templates
  add constraint fk_urltemp_site foreign key (site_id)
  references sites (id)
  on delete cascade
  on update cascade;

alter table url_templates
  add constraint fk_urltemp_temp foreign key (template_id)
  references templates (id)
  on delete cascade
  on update cascade;

alter table user_notes
  add constraint fk_unote_user foreign key (user_id)
  references users (id)
  on delete cascade
  on update cascade;

alter table user_notes
  add constraint fk_unote_note foreign key (note_id)
  references notes (id)
  on delete cascade
  on update cascade;

alter table username_aliases
  add constraint fk_ualias_primary foreign key (primary_username_id)
  references usernames (id)
  on delete cascade
  on update cascade;

alter table username_aliases
  add constraint fk_ualias_alias foreign key (alias_username_id)
  references usernames (id)
  on delete cascade
  on update cascade;

alter table usernames
  add constraint fk_uname_user foreign key (user_id)
  references users (id)
  on delete set null
  on update cascade;

alter table usernames
  add constraint fk_uname_site foreign key (site_id)
  references sites (id)
  on delete cascade
  on update cascade;

alter table usernames
  add constraint fk_uname_type foreign key (type_id)
  references types (id)
  on delete set null
  on update cascade;

alter table usernames
  add constraint fk_uname_status foreign key (status_id)
  references statuses (id)
  on delete set null
  on update cascade;

alter table users
  add constraint fk_user_cntry foreign key (country_id)
  references countries (id)
  on delete set null
  on update cascade;

alter table users
  add constraint fk_user_subdiv foreign key (subdivision_id)
  references country_subdivisions (id)
  on delete set null
  on update cascade;

/*
 * Create update timestamp triggers.
 */
delimiter |

create trigger tr_countries_update
  before update on countries for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_country_subdivisions_update
  before update on country_subdivisions for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_notes_update
  before update on notes for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_sites_update
  before update on sites for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_statuses_update
  before update on statuses for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_templates_update
  before update on templates for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_types_update
  before update on types for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_types_categories_update
  before update on types_categories for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_types_names_update
  before update on types_names for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_url_templates_update
  before update on url_templates for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_user_notes_update
  before update on user_notes for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_username_aliases_update
  before update on username_aliases for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_usernames_update
  before update on usernames for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

create trigger tr_users_update
  before update on users for each row
  begin
    set NEW.last_modified = current_timestamp;
  end
|

delimiter ;

