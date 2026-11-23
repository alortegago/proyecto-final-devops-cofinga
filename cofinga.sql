--
-- PostgreSQL database dump
--

\restrict Oudvbe8O3UoD5rCcSviQ3cEmesMBEub3ENdhzXYqfIHOYk3awZCRiL67QdFNhyh

-- Dumped from database version 17.12 (Debian 17.12-1.pgdg13+1)
-- Dumped by pg_dump version 17.12 (Debian 17.12-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assessments; Type: TABLE; Schema: public; Owner: cofinga
--

CREATE TABLE public.assessments (
    id integer NOT NULL,
    community_id integer NOT NULL,
    concept character varying(200) NOT NULL,
    amount numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.assessments OWNER TO cofinga;

--
-- Name: assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: cofinga
--

CREATE SEQUENCE public.assessments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assessments_id_seq OWNER TO cofinga;

--
-- Name: assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cofinga
--

ALTER SEQUENCE public.assessments_id_seq OWNED BY public.assessments.id;


--
-- Name: communities; Type: TABLE; Schema: public; Owner: cofinga
--

CREATE TABLE public.communities (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(200) NOT NULL
);


ALTER TABLE public.communities OWNER TO cofinga;

--
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: cofinga
--

CREATE SEQUENCE public.communities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.communities_id_seq OWNER TO cofinga;

--
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cofinga
--

ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;


--
-- Name: properties; Type: TABLE; Schema: public; Owner: cofinga
--

CREATE TABLE public.properties (
    id integer NOT NULL,
    community_id integer NOT NULL,
    property_code character varying(10) NOT NULL,
    coefficient numeric(5,2)
);


ALTER TABLE public.properties OWNER TO cofinga;

--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: public; Owner: cofinga
--

CREATE SEQUENCE public.properties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.properties_id_seq OWNER TO cofinga;

--
-- Name: properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cofinga
--

ALTER SEQUENCE public.properties_id_seq OWNED BY public.properties.id;


--
-- Name: assessments id; Type: DEFAULT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.assessments ALTER COLUMN id SET DEFAULT nextval('public.assessments_id_seq'::regclass);


--
-- Name: communities id; Type: DEFAULT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- Name: properties id; Type: DEFAULT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.properties ALTER COLUMN id SET DEFAULT nextval('public.properties_id_seq'::regclass);


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: cofinga
--

COPY public.assessments (id, community_id, concept, amount, created_at) FROM stdin;
1	1	Pintura de fachada	8000.00	2026-11-19 18:05:31.593813
2	2	Sustitucion ascensor	24000.00	2026-11-19 18:05:31.593813
3	3	Impermeabilizacion cubierta	12000.00	2026-11-19 18:05:31.593813
\.


--
-- Data for Name: communities; Type: TABLE DATA; Schema: public; Owner: cofinga
--

COPY public.communities (id, name, address) FROM stdin;
1	Jardines del Sur	Madrid
2	Residencial Sol	Madrid
3	Parque Central	Madrid
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: cofinga
--

COPY public.properties (id, community_id, property_code, coefficient) FROM stdin;
1	1	1A	12.50
2	1	1B	12.50
3	1	2A	12.50
4	1	2B	12.50
5	1	3A	12.50
6	1	3B	12.50
7	1	4A	12.50
8	1	4B	12.50
9	2	1A	12.50
10	2	1B	12.50
11	2	2A	12.50
12	2	2B	12.50
13	2	3A	12.50
14	2	3B	12.50
15	2	4A	12.50
16	2	4B	12.50
17	3	1A	12.50
18	3	1B	12.50
19	3	2A	12.50
20	3	2B	12.50
21	3	3A	12.50
22	3	3B	12.50
23	3	4A	12.50
24	3	4B	12.50
\.


--
-- Name: assessments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cofinga
--

SELECT pg_catalog.setval('public.assessments_id_seq', 3, true);


--
-- Name: communities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cofinga
--

SELECT pg_catalog.setval('public.communities_id_seq', 3, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cofinga
--

SELECT pg_catalog.setval('public.properties_id_seq', 24, true);


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: assessments fk_assessment_community; Type: FK CONSTRAINT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT fk_assessment_community FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: properties fk_community; Type: FK CONSTRAINT; Schema: public; Owner: cofinga
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT fk_community FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Oudvbe8O3UoD5rCcSviQ3cEmesMBEub3ENdhzXYqfIHOYk3awZCRiL67QdFNhyh

