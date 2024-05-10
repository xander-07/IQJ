package database

//
// ------------------------------------------------------------------------------------------------------
// В этом файле хранятся строки с запросами в базы данных (добавления, получения, создания таблиц и т.д.)
// ------------------------------------------------------------------------------------------------------
//

const ( // Запросы создания таблиц
	createTableNews = `
CREATE TABLE IF NOT EXISTS news (
    news_id SERIAL PRIMARY KEY,
    header TEXT NOT NULL,
    link TEXT NOT NULL,
    news_text TEXT NOT NULL,
    image_links TEXT[],
    tags VARCHAR(255)[],
    is_for_students BOOL NOT NULL,
    publication_time TIMESTAMP
);
`

	createTableUsers = `
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    user_is_deleted BOOL NOT NULL DEFAULT FALSE
);
`

	createTableUsersData = `
CREATE TABLE IF NOT EXISTS users_data (
    user_data_id INT PRIMARY KEY REFERENCES users(user_id),
    user_name VARCHAR(255) NOT NULL,
    biography TEXT,
    useful_data TEXT,
    role VARCHAR(50),
    user_data_is_deleted BOOL NOT NULL DEFAULT FALSE
);
`

	createTableStudents = `
CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY REFERENCES users(user_id),
    student_group_id INT NOT NULL,
    student_teachers_ids INT[],
    student_is_deleted BOOL NOT NULL
);
`

	createTableTeachers = `
CREATE TABLE IF NOT EXISTS teachers (
    teacher_id INT PRIMARY KEY REFERENCES users(user_id),
    teachers_students_groups_ids INT[],
    teacher_is_deleted BOOL NOT NULL
);
`

	createTableStudentGroups = `
CREATE TABLE IF NOT EXISTS student_groups (
    students_group_id SERIAL PRIMARY KEY,
    grade INT NOT NULL,
    institute VARCHAR(128) NOT NULL,
    student_group_name VARCHAR(11) NOT NULL,
    student_group_students_ids INT[]
);
`

	createTableClasses = `
	CREATE TABLE IF NOT EXISTS classes (
    class_id SERIAL PRIMARY KEY,
    class_group_ids INT[],
    class_group_names VARCHAR(11)[] NOT NULL,
    class_teacher_id INT,
    class_teacher_name VARCHAR(255),
    count INT NOT NULL,
    weekday INT NOT NULL,
    week INT NOT NULL,
    class_name TEXT,
    class_type TEXT,
    class_location TEXT
);

CREATE INDEX IF NOT EXISTS idx_class_id  ON classes (class_id);
CREATE INDEX IF NOT EXISTS idx_class_teacher_id ON classes (class_teacher_id);
CREATE INDEX IF NOT EXISTS idx_class_student_group_ids ON classes USING GIN (class_group_ids);

`

	createTableAdvertisements = `
CREATE TABLE IF NOT EXISTS advertisements (
    advertisement_id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    creation_date TIMESTAMP,
    expiration_date TIMESTAMP
);
`

	createTableChatMessages = `
CREATE TABLE IF NOT EXISTS chat_messages (
    message_id SERIAL PRIMARY KEY,
    author INT NOT NULL,
    message_dialogue INT NOT NULL,
    message_type VARCHAR(50) NOT NULL,
    message_attachment_id INT,
    message_text TEXT NOT NULL,
    is_special BOOL NOT NULL,
    sending_time TIMESTAMP
);
`

	createTableChatAttachments = `
CREATE TABLE IF NOT EXISTS chat_attachments (
    attachment_id SERIAL PRIMARY KEY,
    attachment_link TEXT NOT NULL
);
`

	createTableDialogues = `
CREATE TABLE IF NOT EXISTS dialogues (
    dialogue_id SERIAL PRIMARY KEY,
    participants INT[] NOT NULL,
    moderators INT[] NOT NULL
);
`
)
