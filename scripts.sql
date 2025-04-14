'Выводит имя, фамилию и дату записи клиентов, записанных на конкретное занятие.'
SELECT
    c.FirstName,
    c.LastName,
    ce.EnrollmentDate
FROM
    Clients c
JOIN
    ClassEnrollments ce ON c.ClientID = ce.ClientID
JOIN
    ClassSchedule cs ON ce.ScheduleID = cs.ScheduleID
WHERE
    cs.ClassID = 2
ORDER BY
    ce.EnrollmentDate;


'Находит тренера с самой высокой текущей зарплатой (с учетом истории зарплат)'    
SELECT
    t.FirstName,
    t.LastName,
    (SELECT Salary FROM TrainerSalaryHistory WHERE TrainerID = t.TrainerID ORDER BY EndDate DESC LIMIT 1) AS CurrentSalary
FROM
    Trainers t
WHERE t.TrainerID IN (SELECT TrainerID FROM TrainerSalaryHistory)
ORDER BY CurrentSalary DESC
LIMIT 1;


'Показывает расписание занятий определенного тренера.'
SELECT
    cl.ClassName,
    cs.DayOfWeek,
    cs.StartTime,
    cs.EndTime
FROM
    ClassSchedule cs
JOIN
    Classes cl ON cs.ClassID = cl.ClassID
WHERE
    cs.TrainerID = 3;


'Показывает действующие абонементы на определенную дату и их стоимость.'
SELECT
    m.MembershipType,
    mph.Price,
    mph.StartDate,
    mph.EndDate
FROM
    Memberships m
JOIN
    MembershipPriceHistory mph ON m.MembershipID = mph.MembershipID
WHERE
    2025-01-01 BETWEEN mph.StartDate AND mph.EndDate
ORDER BY
    m.MembershipType;


'Выводит имена и фамилии клиентов, имеющих абонемент конкретного типа.'
SELECT
    c.FirstName,
    c.LastName
FROM
    Clients c
JOIN
    ClientMemberships cm ON c.ClientID = cm.ClientID
JOIN
    Memberships m ON cm.MembershipID = m.MembershipID
WHERE
    m.MembershipType = 5;


'Вычисляет среднюю продолжительность занятий, которые ведет каждый тренер.'
SELECT
    t.FirstName,
    t.LastName,
    AVG(TIME_TO_SEC(cs.EndTime) - TIME_TO_SEC(cs.StartTime)) / 60 AS AverageClassDurationMinutes
FROM
    ClassSchedule cs
JOIN
    Trainers t ON cs.TrainerID = t.TrainerID
GROUP BY
    t.TrainerID, t.FirstName, t.LastName;


'Находит клиентов, посетивших больше всего занятий, и ранжирует их.'
WITH ClientClassCounts AS (
    SELECT
        ce.ClientID,
        COUNT(*) AS ClassCount
    FROM
        ClassEnrollments ce
    GROUP BY
        ce.ClientID
)
SELECT
    c.FirstName,
    c.LastName,
    ccc.ClassCount,
    RANK() OVER (ORDER BY ccc.ClassCount DESC) AS RankByClassCount
FROM
    Clients c
JOIN
    ClientClassCounts ccc ON c.ClientID = ccc.ClientID
ORDER BY RankByClassCount, ccc.ClassCount DESC;


'Показывает информацию об активных абонементах клиента.'
SELECT
    cm.ClientMembershipID,
    m.MembershipType,
    cm.StartDate,
    cm.EndDate,
    cm.RemainingSessions
FROM
    ClientMemberships cm
JOIN
    Memberships m ON cm.MembershipID = m.MembershipID
WHERE
    cm.ClientID = 14
    AND cm.EndDate >= CURDATE();


'Выводит список клиентов, которые когда-либо были записаны на занятия.'
SELECT
    c.FirstName,
    c.LastName
FROM
    Clients c
WHERE
    EXISTS (
        SELECT 1
        FROM ClassEnrollments ce
        WHERE ce.ClientID = c.ClientID
    );


'Выводит информацию о тренерах, чья текущая зарплата превышает среднюю зарплату всех тренеров.'
SELECT
    t.FirstName,
    t.LastName,
    tsh.Salary
FROM
    Trainers t
JOIN
    TrainerSalaryHistory tsh ON t.TrainerID = tsh.TrainerID
WHERE tsh.EndDate IS NULL AND tsh.Salary > (SELECT AVG(Salary) FROM TrainerSalaryHistory WHERE EndDate IS NULL)
ORDER BY tsh.Salary DESC;
