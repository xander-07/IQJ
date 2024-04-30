CREATE OR REPLACE FUNCTION delete_user_cascade(user_id INT) RETURNS VOID AS $$
BEGIN
    -- Начало транзакции
    BEGIN;

    -- Удаление пользователя из users_data и users
    DELETE FROM users_data WHERE id = user_id;
    DELETE FROM users WHERE id = user_id;

    -- Удаление связанных записей в зависимости от роли пользователя
    DELETE FROM students WHERE id = user_id;
    DELETE FROM teachers WHERE id = user_id;

    -- Обновление массива students в таблице student_groups
    UPDATE student_groups
    SET students = array_remove(students, user_id)
    WHERE user_id = ANY(students);

    -- Обновление расписания, если пользователь был учителем
    UPDATE schedule SET teacher_id = NULL WHERE teacher_id = user_id;

    -- Коммит транзакции
    COMMIT;

    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_groups_to_teacher(teacher_id INT) RETURNS VOID AS $$
DECLARE
    groups_array INT[];
BEGIN
    -- Сформировать массив групп из schedule для указанного учителя
    SELECT array_agg(s.group_id)
    INTO groups_array
    FROM schedule s
    WHERE s.teacher_id = teacher_id;

    -- Обновить массив student_groups только для указанного учителя
    UPDATE teachers
    SET student_groups = groups_array
    WHERE id = teacher_id;

    RETURN;
END;
$$ LANGUAGE plpgsql;
