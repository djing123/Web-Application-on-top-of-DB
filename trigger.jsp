--
--  MS4, section schedule conflict
--

CREATE OR REPLACE FUNCTION schedule_conflict() RETURNS trigger AS
$$
    BEGIN
		IF EXISTS (
            SELECT s.section_id, s.date, s.time
            FROM schedule s
            WHERE s.section_id = NEW.section_id AND s.date = NEW.date AND s.time = NEW.time
        )
        THEN RAISE EXCEPTION 'Insertion Error: Schedule Conflict, with Section_ID: %, Date on %, Time at %.', 
        NEW.section_id, NEW.date, NEW.time;
        END IF;
        RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS schedule_tri ON schedule;
CREATE TRIGGER schedule_tri
BEFORE INSERT OR UPDATE ON schedule
FOR EACH ROW EXECUTE PROCEDURE schedule_conflict();



--
--  MS4, student enrollment limit conflict
--

CREATE OR REPLACE FUNCTION student_limit()
RETURNS trigger AS
$$
BEGIN
    IF EXISTS (
        SELECT c.enrollment_limit
        FROM classes c
        WHERE c.enrollment_limit = (
            SELECT count(e.student_id)
            FROM courseenrollment e
            WHERE e.section_id = NEW.section_id AND c.section_id = e.section_id
            )
        )
    THEN RAISE EXCEPTION 'Section: %, its total number of enrolled student reach the class limit, enrollment is rejected', NEW.section_id;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS enroll_tri ON courseenrollment;
CREATE TRIGGER enroll_tri
BEFORE INSERT ON courseenrollment
FOR EACH ROW EXECUTE PROCEDURE student_limit();


--
-- MS4, professor limited section
--

CREATE OR REPLACE FUNCTION professor_limit()
RETURNS trigger AS
$$
BEGIN
    CREATE TEMP TABLE professor_schedule ON COMMIT DROP AS
    SELECT sc1.date, sc1.time
    FROM schedule sc1
        WHERE sc1.section_id IN (
        SELECT s.section_id
        FROM section s
        WHERE s.faculty = NEW.faculty );

    CREATE TEMP TABLE section_schedule ON COMMIT DROP AS
    SELECT sc2.date, sc2.time
    FROM schedule sc2
    WHERE sc2.section_id = NEW.section_id AND sc2.kind = 'Letture';

    IF EXISTS (
        SELECT ps.date, ps.time
        FROM professor_schedule ps, section_schedule sec
        WHERE ps.date = sec.date AND ps.time = sec.time
    )
    THEN RAISE EXCEPTION 'Professor % can not teach this section, because there is another section he/she is teaching at the same time', NEW.faculty;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS professor_tri ON section;
CREATE TRIGGER professor_tri
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW EXECUTE PROCEDURE professor_limit();



--
--  MS5
--
CREATE TABLE CPQG AS
(   SELECT A1.COURSE AS COURSE, A1.Professor AS Professor, A1.QUARTER AS QUARTER, A1.YEAR AS YEAR,
    CASE WHEN A1.GRADE IN ('A+', 'A', 'A-') THEN 'A'  WHEN A1.GRADE IN ('B+', 'B', 'B-') THEN 'B'
    WHEN A1.GRADE IN ('C+', 'C', 'C-') THEN 'C' WHEN A1.GRADE IN ('D') THEN 'D' ELSE 'OTHER' END AS GRADE,
    COUNT(A1.GRADE) AS COUNT FROM (SELECT DISTINCT p.grade AS GRADE, p.student_id, p.course AS COURSE,
    s.faculty AS Professor, c.quarter AS QUARTER, c.year AS YEAR
    FROM classestakeninpast p, section s, classes c 
    WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id
    AND p.quarter = c.quarter AND p.year = c.year
    AND p.grade IN (SELECT letter_grade FROM grade_conversion)) AS A1 GROUP BY A1.COURSE, A1.Professor, A1.QUARTER, A1.YEAR, CASE WHEN A1.GRADE IN ('A+', 'A', 'A-') THEN 'A' WHEN A1.GRADE IN ('B+', 'B', 'B-') THEN 'B' WHEN A1.GRADE IN ('C+', 'C', 'C-') THEN 'C'
    WHEN A1.GRADE IN ('D') THEN 'D'ELSE 'OTHER' END );

CREATE TABLE CPG AS (
   SELECT A1.COURSE AS COURSE, A1.Professor AS Professor, CASE WHEN A1.GRADE IN ('A+', 'A', 'A-') THEN 'A'  WHEN A1.GRADE IN ('B+', 'B', 'B-') THEN 'B' WHEN A1.GRADE IN ('C+', 'C', 'C-') THEN 'C' WHEN A1.GRADE IN ('D') THEN 'D' ELSE 'OTHER' END AS GRADE, COUNT(A1.GRADE) AS COUNT
   FROM (SELECT DISTINCT p.grade AS GRADE, p.student_id, p.course AS COURSE, s.faculty AS Professor FROM classestakeninpast p, section s, classes c WHERE p.course = c.course_number AND c.section_id = s.section_id AND p.section_id = c.section_id AND p.grade IN (SELECT letter_grade FROM grade_conversion)) AS A1
   GROUP BY A1.COURSE, A1.Professor, CASE WHEN A1.GRADE IN ('A+', 'A', 'A-') THEN 'A' WHEN A1.GRADE IN ('B+', 'B', 'B-') THEN 'B' WHEN A1.GRADE IN ('C+', 'C', 'C-') THEN 'C' WHEN A1.GRADE IN ('D') THEN 'D'ELSE 'OTHER' END
)






