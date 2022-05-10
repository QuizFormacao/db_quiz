create sequence stage_id_seq
    as integer;

alter sequence stage_id_seq owner to postgres;

create table school_class
(
    id          serial
        constraint school_class_pk
            primary key,
    name        varchar not null,
    institution varchar not null
);

comment on table school_class is 'Students class';

alter table school_class
    owner to postgres;

create unique index school_class_id_uindex
    on school_class (id);

create table student
(
    id                serial
        constraint student_pk
            primary key,
    name              varchar     not null,
    email             varchar     not null,
    registration_code varchar     not null,
    school_class_id   integer     not null
        constraint school_class_id
            references school_class,
    password          varchar(20) not null
);

alter table student
    owner to postgres;

create unique index student_email_uindex
    on student (email);

create unique index student_id_uindex
    on student (id);

create unique index student_registration_code_uindex
    on student (registration_code);

create table professor
(
    id       serial
        constraint professor_pk
            primary key,
    name     varchar     not null,
    email    varchar     not null,
    password varchar(20) not null,
    subject  varchar     not null
);

alter table professor
    owner to postgres;

create table training_courses
(
    id           serial
        constraint training_courses_pk
            primary key,
    name         varchar not null,
    professor_id integer not null
        constraint professor_id_fk
            references professor
);

comment on table training_courses is 'Professor training courses';

alter table training_courses
    owner to postgres;

create unique index training_courses_id_uindex
    on training_courses (id);

create unique index professor_email_uindex
    on professor (email);

create unique index professor_id_uindex
    on professor (id);

create table question
(
    id              serial
        constraint question_pk
            primary key,
    description     varchar not null,
    difficult_level varchar not null,
    professor_id    integer not null
        constraint professor_id_fk
            references professor
);

comment on table question is 'A question create by a teacher to put on a game';

alter table question
    owner to postgres;

create unique index question_id_uindex
    on question (id);

create table alternative
(
    id          serial
        constraint alternative_pk
            primary key,
    description varchar               not null,
    is_correct  boolean default false not null,
    question_id integer               not null
        constraint question_id_fk
            references question
);

comment on table alternative is 'Question alternatives';

alter table alternative
    owner to postgres;

create unique index alternative_id_uindex
    on alternative (id);

create table game
(
    id              serial
        constraint game_pk
            primary key,
    title           varchar              not null,
    difficult_level varchar              not null,
    school_class_id integer              not null
        constraint school_class_id
            references school_class,
    is_active       boolean default true not null
);

comment on table game is 'A game create by a professor';

alter table game
    owner to postgres;

create unique index game_id_uindex
    on game (id);

create table stage
(
    id      integer default nextval('stage_id_seq'::regclass) not null
        constraint stage_pk
            primary key,
    game_id integer                                           not null
        constraint game_id_fk
            references game
);

comment on table stage is 'A game stage';

alter table stage
    owner to postgres;

alter sequence stage_id_seq owned by stage.id;

create unique index stage_id_uindex
    on stage (id);

create table stage_question
(
    stage_id    integer not null
        constraint stage_id_fk
            references stage,
    question_id integer not null
        constraint question_id
            references question
);

comment on table stage_question is 'Questions of a stage';

alter table stage_question
    owner to postgres;

create table student_game_execution
(
    id                  serial
        constraint student_game_execution_pk
            primary key,
    game_id             integer   not null
        constraint game_id_fk
            references game,
    student_id          integer   not null
        constraint student_id_fk
            references student,
    start_date          timestamp not null,
    end_date            timestamp,
    current_stage_id    integer   not null
        constraint current_stage_id_fk
            references stage,
    current_question_id integer   not null
        constraint current_question_id_fk
            references question,
    score               double precision default 0
);

comment on table student_game_execution is 'A game execution by a student';

alter table student_game_execution
    owner to postgres;

create unique index student_game_execution_id_uindex
    on student_game_execution (id);

create table student_answers
(
    id                      serial
        constraint student_answers_pk
            primary key,
    student_id              integer not null
        constraint student_id_fk
            references student,
    game_execution_id       integer not null
        constraint game_execution_id_fk
            references student_game_execution,
    question_id             integer not null
        constraint question_id_fk
            references question,
    alternative_answered_id integer not null
        constraint alternative_answered_id_fk
            references alternative
);

comment on table student_answers is 'Student question answers';

alter table student_answers
    owner to postgres;

create unique index student_answers_id_uindex
    on student_answers (id);


