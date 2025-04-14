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


SELECT
    t.FirstName,
    t.LastName,
    (SELECT Salary FROM TrainerSalaryHistory WHERE TrainerID = t.TrainerID ORDER BY EndDate DESC LIMIT 1) AS CurrentSalary
FROM
    Trainers t
WHERE t.TrainerID IN (SELECT TrainerID FROM TrainerSalaryHistory)
ORDER BY CurrentSalary DESC
LIMIT 1;


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
    2025-01-01 BETWEEN mph.StartDate AND mph.EndDate  -- Например, '2024-07-15'
ORDER BY
    m.MembershipType;


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
