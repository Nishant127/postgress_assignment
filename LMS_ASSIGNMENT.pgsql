--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: calc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (NEW.date_returned - OLD.date_issue)>15 THEN
		INSERT INTO book_fines(issue_book_id,fine) VALUES (old.id,(NEW.date_returned - OLD.date_return)*5);
	END IF;
	
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.calc() OWNER TO postgres;

--
-- Name: member_books_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.member_books_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE books SET book_items = book_items-1 WHERE id=NEW.book_id;
	UPDATE members SET issued_books = issued_books+1 WHERE id=NEW.member_id;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.member_books_limit() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: book_fines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_fines (
    id bigint NOT NULL,
    issue_book_id bigint NOT NULL,
    fine integer
);


ALTER TABLE public.book_fines OWNER TO postgres;

--
-- Name: book_fines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_fines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_fines_id_seq OWNER TO postgres;

--
-- Name: book_fines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_fines_id_seq OWNED BY public.book_fines.id;


--
-- Name: book_fines_issue_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_fines_issue_book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_fines_issue_book_id_seq OWNER TO postgres;

--
-- Name: book_fines_issue_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_fines_issue_book_id_seq OWNED BY public.book_fines.issue_book_id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id bigint NOT NULL,
    title character varying(20) NOT NULL,
    author character varying(20) NOT NULL,
    pub_date date NOT NULL,
    sub_cat character varying(20) NOT NULL,
    rack_no integer NOT NULL,
    book_items integer NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_seq OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: issued_books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issued_books (
    id bigint NOT NULL,
    member_id bigint NOT NULL,
    book_id bigint NOT NULL,
    date_issue date,
    date_return date,
    date_returned date,
    issue_status character varying(15)
);


ALTER TABLE public.issued_books OWNER TO postgres;

--
-- Name: issue_books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_books_book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_books_book_id_seq OWNER TO postgres;

--
-- Name: issue_books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_books_book_id_seq OWNED BY public.issued_books.book_id;


--
-- Name: issue_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_books_id_seq OWNER TO postgres;

--
-- Name: issue_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_books_id_seq OWNED BY public.issued_books.id;


--
-- Name: issue_books_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issue_books_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.issue_books_member_id_seq OWNER TO postgres;

--
-- Name: issue_books_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issue_books_member_id_seq OWNED BY public.issued_books.member_id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    id bigint NOT NULL,
    member_name character varying(50) NOT NULL,
    city character varying(15) NOT NULL,
    date_register date NOT NULL,
    issued_books integer,
    email character varying(30),
    CONSTRAINT members_books_limit_check CHECK (((issued_books <= 5) AND (issued_books > 0)))
);


ALTER TABLE public.members OWNER TO postgres;

--
-- Name: members_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.members_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.members_member_id_seq OWNER TO postgres;

--
-- Name: members_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.members_member_id_seq OWNED BY public.members.id;


--
-- Name: book_fines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_fines ALTER COLUMN id SET DEFAULT nextval('public.book_fines_id_seq'::regclass);


--
-- Name: book_fines issue_book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_fines ALTER COLUMN issue_book_id SET DEFAULT nextval('public.book_fines_issue_book_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: issued_books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books ALTER COLUMN id SET DEFAULT nextval('public.issue_books_id_seq'::regclass);


--
-- Name: issued_books member_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books ALTER COLUMN member_id SET DEFAULT nextval('public.issue_books_member_id_seq'::regclass);


--
-- Name: issued_books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books ALTER COLUMN book_id SET DEFAULT nextval('public.issue_books_book_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_member_id_seq'::regclass);


--
-- Data for Name: book_fines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_fines (id, issue_book_id, fine) FROM stdin;
3	6	10
4	16	15
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, title, author, pub_date, sub_cat, rack_no, book_items) FROM stdin;
1	The Alchemist	Paulo Cohelo	2011-01-01	Inspirational	101	10
2	The Four Agreements	Don Miguel Ruiz	2000-01-01	Literature	102	7
5	Five Point Someone	 Chetan Bhagat	2004-01-03	Fiction	107	2
3	Sherlock Holmes	Arthur Conan Doyle	2005-07-10	Mystery	104	14
4	Wings of fire	A. P. J. Abdul Kalam	1999-05-09	Biography	105	3
\.


--
-- Data for Name: issued_books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issued_books (id, member_id, book_id, date_issue, date_return, date_returned, issue_status) FROM stdin;
1	1	4	2021-04-05	2021-04-21	2021-04-17	Returned
3	1	3	2021-04-21	2021-05-06	2021-05-03	Returned
4	2	5	2021-05-01	2021-05-15	2021-05-15	Returned
5	3	3	2021-04-01	2021-04-15	2021-04-20	Returned
7	5	1	2020-07-01	2020-07-15	2020-07-15	Returned
8	5	2	2021-03-01	2021-03-15	2021-04-05	Returned
2	2	5	2021-05-15	2021-05-31	\N	Not Returned
6	4	1	2021-06-01	2021-06-15	2021-06-17	Returned
16	4	3	2021-06-10	2021-06-25	2021-06-28	Returned
17	1	4	2021-05-11	2021-05-26	2021-05-24	Returned
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (id, member_name, city, date_register, issued_books, email) FROM stdin;
2	Jesse Pinkman	Pune	2021-02-10	2	pinkman@gmail.com
3	Saul Goodman	Bangalore	2021-03-05	1	ikownaguy@gmail.com
5	Srikant Tiwari	Mumbai	2020-01-01	2	tasc@gmail.com
4	Professor	Pune	2021-06-01	2	heist@gmail.com
1	Walter White	Pune	2021-04-04	3	heisenberg@gmail.com
\.


--
-- Name: book_fines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_fines_id_seq', 4, true);


--
-- Name: book_fines_issue_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_fines_issue_book_id_seq', 1, false);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 5, true);


--
-- Name: issue_books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_books_book_id_seq', 1, false);


--
-- Name: issue_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_books_id_seq', 17, true);


--
-- Name: issue_books_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issue_books_member_id_seq', 1, false);


--
-- Name: members_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.members_member_id_seq', 5, true);


--
-- Name: book_fines book_fines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_fines
    ADD CONSTRAINT book_fines_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: issued_books issue_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issue_books_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: issued_books books_limit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER books_limit AFTER INSERT ON public.issued_books FOR EACH ROW EXECUTE FUNCTION public.member_books_limit();


--
-- Name: issued_books calc_fine; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER calc_fine AFTER UPDATE ON public.issued_books FOR EACH ROW EXECUTE FUNCTION public.calc();


--
-- Name: book_fines book_fines_issue_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_fines
    ADD CONSTRAINT book_fines_issue_book_id_fkey FOREIGN KEY (issue_book_id) REFERENCES public.issued_books(id);


--
-- Name: issued_books issue_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issue_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: issued_books issue_books_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issued_books
    ADD CONSTRAINT issue_books_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id);


--
-- PostgreSQL database dump complete
--

