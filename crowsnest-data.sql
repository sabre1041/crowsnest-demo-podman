--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: capability_history(); Type: FUNCTION; Schema: public; Owner: telescope
--

CREATE FUNCTION public.capability_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        capability_history(capability_id,flag)
        VALUES(new.id,new.flag_id);
           RETURN new;
END;
$$;


ALTER FUNCTION public.capability_history() OWNER TO telescope;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: capability; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.capability (
    id integer NOT NULL,
    domain_id integer,
    flag_id integer,
    description character varying(128),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.capability OWNER TO telescope;

--
-- Name: capability_history; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.capability_history (
    id integer NOT NULL,
    capability_id integer,
    flag integer,
    updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.capability_history OWNER TO telescope;

--
-- Name: capability_history_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.capability_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.capability_history_id_seq OWNER TO telescope;

--
-- Name: capability_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: telescope
--

ALTER SEQUENCE public.capability_history_id_seq OWNED BY public.capability_history.id;


--
-- Name: capability_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.capability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.capability_id_seq OWNER TO telescope;

--
-- Name: capability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: telescope
--

ALTER SEQUENCE public.capability_id_seq OWNED BY public.capability.id;


--
-- Name: domain; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.domain (
    id integer NOT NULL,
    description character varying(128),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.domain OWNER TO telescope;

--
-- Name: domain_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.domain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.domain_id_seq OWNER TO telescope;

--
-- Name: domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: telescope
--

ALTER SEQUENCE public.domain_id_seq OWNED BY public.domain.id;


--
-- Name: flag; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.flag (
    id integer NOT NULL,
    description character varying(128),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.flag OWNER TO telescope;

--
-- Name: flag_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.flag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flag_id_seq OWNER TO telescope;

--
-- Name: flag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: telescope
--

ALTER SEQUENCE public.flag_id_seq OWNED BY public.flag.id;


--
-- Name: integration_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.integration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.integration_id_seq OWNER TO telescope;

--
-- Name: integration_methods; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.integration_methods (
    integration_method_name character varying,
    id bigint NOT NULL
);


ALTER TABLE public.integration_methods OWNER TO telescope;

--
-- Name: integration_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.integration_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 1;


ALTER SEQUENCE public.integration_methods_id_seq OWNER TO telescope;

--
-- Name: integration_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: telescope
--

ALTER SEQUENCE public.integration_methods_id_seq OWNED BY public.integration_methods.id;


--
-- Name: integrations; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.integrations (
    integration_id bigint DEFAULT nextval('public.integration_id_seq'::regclass) NOT NULL,
    capability_id integer,
    url character varying(300),
    "user" character varying(100),
    password character varying(100),
    token character varying(5000),
    success_criteria character varying(100),
    last_update timestamp with time zone,
    integration_name character varying(100),
    integration_method_id bigint,
    hash character(5)
);


ALTER TABLE public.integrations OWNER TO telescope;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: telescope
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq OWNER TO telescope;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: telescope
--

CREATE TABLE public.profiles (
    id integer DEFAULT nextval('public.profiles_id_seq'::regclass) NOT NULL,
    name character varying(128),
    description character varying(128),
    domains integer[]
);


ALTER TABLE public.profiles OWNER TO telescope;

--
-- Name: capability id; Type: DEFAULT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.capability ALTER COLUMN id SET DEFAULT nextval('public.capability_id_seq'::regclass);


--
-- Name: capability_history id; Type: DEFAULT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.capability_history ALTER COLUMN id SET DEFAULT nextval('public.capability_history_id_seq'::regclass);


--
-- Name: domain id; Type: DEFAULT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.domain ALTER COLUMN id SET DEFAULT nextval('public.domain_id_seq'::regclass);


--
-- Name: flag id; Type: DEFAULT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.flag ALTER COLUMN id SET DEFAULT nextval('public.flag_id_seq'::regclass);


--
-- Name: integration_methods id; Type: DEFAULT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.integration_methods ALTER COLUMN id SET DEFAULT nextval('public.integration_methods_id_seq'::regclass);


--
-- Data for Name: capability; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.capability (id, domain_id, flag_id, description, created_at) FROM stdin;
55	13	2	Device Threat Protection	2023-10-06 15:32:38.35061
56	13	2	Policy Enforcement	2023-10-06 15:33:05.119296
57	13	2	Resource Access	2023-10-06 15:33:19.960765
34	13	2	Risk Assessments	2023-10-06 15:18:30.44223
43	14	2	Accessible Applications	2023-10-06 15:22:05.877366
44	14	2	Application Access	2023-10-06 15:22:20.977352
45	14	2	Application Security Testing	2023-10-06 15:22:42.86989
46	14	2	Application Threat Protections	2023-10-06 15:23:00.305145
37	14	2	Device Threat Protection	2023-10-06 15:19:49.58944
38	14	2	Policy Enforcement	2023-10-06 15:20:03.379245
35	14	2	Resource Access	2023-10-06 15:19:15.829315
36	14	2	Supply Chain Risk Management	2023-10-06 15:19:34.224251
47	15	2	Data Access	2023-10-06 15:23:33.053765
48	15	2	Data Availability	2023-10-06 15:23:44.105081
49	15	2	Data Categorization	2023-10-06 15:23:56.604482
50	15	1	Data Encryption	2023-10-06 15:24:08.347428
51	15	2	Data Inventory Management	2023-10-06 15:24:21.317944
39	16	2	Network Resilience	2023-10-06 15:20:43.423782
40	16	2	Network Segmentation	2023-10-06 15:20:56.914121
41	16	2	Network Traffic Management	2023-10-06 15:21:10.478316
42	16	2	Traffic Encryption	2023-10-06 15:21:24.9588
31	17	1	Access Management	2023-10-06 15:08:15.534594
32	17	1	Authentication	2023-10-06 15:17:59.242437
33	17	1	Identity Stores	2023-10-06 15:18:16.639232
52	18	1	Automation and Orchestration	2023-10-06 15:27:06.048685
53	18	2	Governance	2023-10-06 15:27:16.894685
54	18	2	Visibility and Analytics	2023-10-06 15:27:29.431084
9	1	2	Container Protection	2023-01-05 12:06:38.023359
8	1	2	Platform Hardening	2023-01-05 12:06:29.110498
1	1	2	Secure Images	2023-01-05 12:05:28.265165
2	2	2	Classification	2023-01-05 12:05:28.270549
3	2	2	Encryption at Rest	2023-01-05 12:05:28.272751
10	2	2	Vulnerability Scanning	2023-01-05 12:06:50.545384
60	3	2	DAST	2023-10-12 12:46:45.190308
59	3	2	SAST	2023-10-12 12:46:39.490502
61	3	1	Validated SBOM	2023-10-12 12:46:59.907279
62	4	2	Encryption in Transit	2023-10-12 12:52:03.309656
63	4	2	Firewalls	2023-10-12 12:52:18.607406
64	4	2	Policy	2023-10-12 12:52:33.478537
65	5	1	Asset Management	2023-10-12 12:53:39.222796
67	5	2	IDS/IPS	2023-10-12 12:54:56.844442
68	5	2	SIEM	2023-10-12 12:55:08.580479
132	30	2	Anomaly Detection	2024-11-18 08:11:31.959755
130	30	2	Login Thresholds	2024-11-18 08:11:08.221745
131	30	2	Network Traffic Spike Monitoring	2024-11-18 08:11:19.585541
134	31	2	Alerting	2024-11-18 08:11:47.499879
133	31	2	SIEM	2024-11-18 08:11:38.728814
135	31	2	Traffic Monitoring	2024-11-18 08:11:58.429505
136	32	2	Detection Rule Updates	2024-11-18 08:12:08.350941
137	32	1	Pen Testing	2024-11-18 08:12:16.980239
138	32	2	Training	2024-11-18 08:12:23.622543
87	20	2	Asset Classification	2024-11-18 08:00:44.686729
84	20	1	Asset Discovery	2024-11-18 08:00:13.197638
85	20	2	Centralized Inventory	2024-11-18 08:00:21.261265
89	20	2	Dependency Mapping	2024-11-18 08:01:09.031546
88	20	1	Identify Supporting Systems	2024-11-18 08:00:59.987622
86	20	1	Inventory Updates	2024-11-18 08:00:28.275761
90	21	2	Identify Critical Functions	2024-11-18 08:01:22.615959
91	21	2	Priority Management	2024-11-18 08:01:33.794971
92	21	2	Priority Mapping	2024-11-18 08:01:42.780109
102	42	2	Document Roles	2024-11-18 08:05:03.69312
100	42	1	Establish Committee	2024-11-18 08:04:43.59407
101	42	2	Role Assignment - Policy	2024-11-18 08:04:57.309689
96	23	2	Risk Scoring	2024-11-18 08:03:16.4065
97	23	2	Threat Modeling	2024-11-18 08:03:26.271272
98	23	2	Vulnerability Evaluation	2024-11-18 08:03:40.983119
105	41	2	Monitor Risk Changes  - Environment	2024-11-18 08:05:55.064956
104	41	2	Risk Appetite Alignment	2024-11-18 08:05:37.996222
103	41	2	Risk Tolerance Statement	2024-11-18 08:05:28.465978
108	24	1	Contract Clauses	2024-11-18 08:06:28.966227
107	24	1	Monitor 3rd Party Compliance	2024-11-18 08:06:18.266968
106	24	1	Vet Vendors	2024-11-18 08:06:04.101034
83	25	2	Access Review	2024-11-18 07:59:50.497848
82	25	1	JIT	2024-11-18 07:59:41.112598
109	25	2	MFA	2024-11-18 08:06:48.995827
110	25	2	Password Policy Enforcement	2024-11-18 08:07:02.016549
111	25	2	Password Rotation	2024-11-18 08:07:09.873081
81	25	2	RBAC	2024-11-18 07:59:34.405016
113	26	2	Cyber Training	2024-11-18 08:07:29.861191
112	26	2	Phishing Awareness	2024-11-18 08:07:21.119884
114	26	1	Training Completion	2024-11-18 08:07:40.484347
117	43	2	DLP	2024-11-18 08:08:39.014154
115	43	2	Encrypt Data	2024-11-18 08:08:17.85867
116	43	2	Secure Protocol Use	2024-11-18 08:08:31.023313
121	27	2	Automated Backup	2024-11-18 08:09:19.129624
123	27	1	Backup Restore Test	2024-11-18 08:09:37.325032
122	27	2	Backup Storage	2024-11-18 08:09:27.17375
119	27	1	Config Audit	2024-11-18 08:09:02.181214
118	27	2	Config Management	2024-11-18 08:08:51.568056
120	27	1	Hardened Baselines	2024-11-18 08:09:10.077377
124	28	2	Maintenance Access Restriction	2024-11-18 08:09:52.73361
125	28	2	Monitor Maintenance Activity	2024-11-18 08:10:07.80035
126	28	2	Post-Maintenance Integrity	2024-11-18 08:10:22.186555
128	29	2	Endpoint Protection	2024-11-18 08:10:47.896778
127	29	2	IDS/IPS	2024-11-18 08:10:38.666348
129	29	1	Patching	2024-11-18 08:10:53.613532
158	40	2	Stakeholder Notification	2024-11-18 08:16:25.637155
159	40	2	Transparency	2024-11-18 08:16:33.103778
156	39	2	Gap Analysis	2024-11-18 08:16:01.87321
157	39	1	Playbook Updates	2024-11-18 08:16:12.29981
154	38	2	Contingency Planning	2024-11-18 08:15:35.052721
153	38	2	Recovery Playbooks	2024-11-18 08:15:24.36324
155	38	2	Role Assignment - Recovery	2024-11-18 08:15:47.863189
145	35	2	Forensic Collection	2024-11-18 08:13:51.182253
146	35	2	Root Cause Analysis	2024-11-18 08:13:58.690418
142	34	2	Contact List	2024-11-18 08:13:22.576404
144	34	2	Document Impact	2024-11-18 08:13:38.296114
143	34	2	Secure Channels	2024-11-18 08:13:29.903804
151	37	1	Adjustment Process	2024-11-18 08:15:04.249969
152	37	2	Implement Changes	2024-11-18 08:15:13.971177
150	37	2	Post-Incident Review	2024-11-18 08:14:50.98554
148	36	2	IP Blocking	2024-11-18 08:14:23.31482
149	36	2	Malware Removal	2024-11-18 08:14:39.706457
147	36	2	System Isolation	2024-11-18 08:14:11.764965
139	33	2	Define Roles - Incident Response	2024-11-18 08:12:49.720418
140	33	2	Escalation Procedures	2024-11-18 08:13:00.307796
141	33	2	Tabletop Excercises	2024-11-18 08:13:12.107201
\.


--
-- Data for Name: capability_history; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.capability_history (id, capability_id, flag, updated) FROM stdin;
728	9	2	2024-11-18 07:51:01.049679
729	8	2	2024-11-18 07:51:01.049679
730	1	2	2024-11-18 07:51:01.049679
731	2	2	2024-11-18 07:51:01.049679
732	3	2	2024-11-18 07:51:01.049679
733	10	2	2024-11-18 07:51:01.049679
734	60	2	2024-11-18 07:51:01.049679
735	59	1	2024-11-18 07:51:01.049679
736	61	1	2024-11-18 07:51:01.049679
737	62	2	2024-11-18 07:51:01.049679
738	63	2	2024-11-18 07:51:01.049679
739	64	2	2024-11-18 07:51:01.049679
740	65	1	2024-11-18 07:51:01.049679
741	67	2	2024-11-18 07:51:01.049679
742	68	1	2024-11-18 07:51:01.049679
743	9	2	2024-11-18 07:51:27.375175
744	8	2	2024-11-18 07:51:27.375175
745	1	2	2024-11-18 07:51:27.375175
746	2	2	2024-11-18 07:51:27.375175
747	3	2	2024-11-18 07:51:27.375175
748	10	2	2024-11-18 07:51:27.375175
749	60	2	2024-11-18 07:51:27.375175
750	59	1	2024-11-18 07:51:27.375175
751	61	1	2024-11-18 07:51:27.375175
752	62	2	2024-11-18 07:51:27.375175
753	63	2	2024-11-18 07:51:27.375175
754	64	2	2024-11-18 07:51:27.375175
755	65	1	2024-11-18 07:51:27.375175
756	67	2	2024-11-18 07:51:27.375175
757	68	2	2024-11-18 07:51:27.375175
758	132	2	2024-11-18 08:19:32.154959
759	130	2	2024-11-18 08:19:32.154959
760	131	2	2024-11-18 08:19:32.154959
761	134	2	2024-11-18 08:19:32.154959
762	133	2	2024-11-18 08:19:32.154959
763	135	2	2024-11-18 08:19:32.154959
764	136	2	2024-11-18 08:19:32.154959
765	137	1	2024-11-18 08:19:32.154959
766	138	2	2024-11-18 08:19:32.154959
767	87	2	2024-11-18 08:19:32.154959
768	84	1	2024-11-18 08:19:32.154959
769	85	2	2024-11-18 08:19:32.154959
770	89	2	2024-11-18 08:19:32.154959
771	88	1	2024-11-18 08:19:32.154959
772	86	1	2024-11-18 08:19:32.154959
773	90	2	2024-11-18 08:19:32.154959
774	91	2	2024-11-18 08:19:32.154959
775	92	2	2024-11-18 08:19:32.154959
776	102	2	2024-11-18 08:19:32.154959
777	100	1	2024-11-18 08:19:32.154959
778	101	2	2024-11-18 08:19:32.154959
779	96	2	2024-11-18 08:19:32.154959
780	97	2	2024-11-18 08:19:32.154959
781	98	2	2024-11-18 08:19:32.154959
782	105	2	2024-11-18 08:19:32.154959
783	104	2	2024-11-18 08:19:32.154959
784	103	2	2024-11-18 08:19:32.154959
785	108	1	2024-11-18 08:19:32.154959
786	107	1	2024-11-18 08:19:32.154959
787	106	1	2024-11-18 08:19:32.154959
788	83	2	2024-11-18 08:19:32.154959
789	82	1	2024-11-18 08:19:32.154959
790	109	2	2024-11-18 08:19:32.154959
791	110	2	2024-11-18 08:19:32.154959
792	111	2	2024-11-18 08:19:32.154959
793	81	2	2024-11-18 08:19:32.154959
794	113	2	2024-11-18 08:19:32.154959
795	112	2	2024-11-18 08:19:32.154959
796	114	1	2024-11-18 08:19:32.154959
797	117	2	2024-11-18 08:19:32.154959
798	115	2	2024-11-18 08:19:32.154959
799	116	2	2024-11-18 08:19:32.154959
800	121	2	2024-11-18 08:19:32.154959
801	123	1	2024-11-18 08:19:32.154959
802	122	2	2024-11-18 08:19:32.154959
803	119	1	2024-11-18 08:19:32.154959
804	118	2	2024-11-18 08:19:32.154959
805	120	1	2024-11-18 08:19:32.154959
806	124	2	2024-11-18 08:19:32.154959
807	125	2	2024-11-18 08:19:32.154959
808	126	2	2024-11-18 08:19:32.154959
809	128	2	2024-11-18 08:19:32.154959
810	127	2	2024-11-18 08:19:32.154959
811	129	1	2024-11-18 08:19:32.154959
812	158	2	2024-11-18 08:19:32.154959
813	159	2	2024-11-18 08:19:32.154959
814	156	2	2024-11-18 08:19:32.154959
815	157	1	2024-11-18 08:19:32.154959
816	154	2	2024-11-18 08:19:32.154959
817	153	2	2024-11-18 08:19:32.154959
818	155	2	2024-11-18 08:19:32.154959
819	145	2	2024-11-18 08:19:32.154959
820	146	2	2024-11-18 08:19:32.154959
821	142	2	2024-11-18 08:19:32.154959
822	144	2	2024-11-18 08:19:32.154959
823	143	2	2024-11-18 08:19:32.154959
824	151	1	2024-11-18 08:19:32.154959
825	152	2	2024-11-18 08:19:32.154959
826	150	2	2024-11-18 08:19:32.154959
827	148	2	2024-11-18 08:19:32.154959
828	149	2	2024-11-18 08:19:32.154959
829	147	2	2024-11-18 08:19:32.154959
830	139	2	2024-11-18 08:19:32.154959
831	140	2	2024-11-18 08:19:32.154959
832	141	2	2024-11-18 08:19:32.154959
833	55	2	2024-11-18 08:20:20.532238
834	56	2	2024-11-18 08:20:20.532238
835	57	2	2024-11-18 08:20:20.532238
836	34	2	2024-11-18 08:20:20.532238
837	43	2	2024-11-18 08:20:20.532238
838	44	2	2024-11-18 08:20:20.532238
839	45	2	2024-11-18 08:20:20.532238
840	46	2	2024-11-18 08:20:20.532238
841	37	2	2024-11-18 08:20:20.532238
842	38	2	2024-11-18 08:20:20.532238
843	35	2	2024-11-18 08:20:20.532238
844	36	2	2024-11-18 08:20:20.532238
845	47	2	2024-11-18 08:20:20.532238
846	48	2	2024-11-18 08:20:20.532238
847	49	2	2024-11-18 08:20:20.532238
848	50	1	2024-11-18 08:20:20.532238
849	51	2	2024-11-18 08:20:20.532238
850	39	2	2024-11-18 08:20:20.532238
851	40	2	2024-11-18 08:20:20.532238
852	41	2	2024-11-18 08:20:20.532238
853	42	2	2024-11-18 08:20:20.532238
854	31	1	2024-11-18 08:20:20.532238
855	32	1	2024-11-18 08:20:20.532238
856	33	1	2024-11-18 08:20:20.532238
857	52	1	2024-11-18 08:20:20.532238
858	53	2	2024-11-18 08:20:20.532238
859	54	2	2024-11-18 08:20:20.532238
860	9	2	2024-11-18 12:20:14.151157
861	8	2	2024-11-18 12:20:14.151157
862	1	2	2024-11-18 12:20:14.151157
863	2	2	2024-11-18 12:20:14.151157
864	3	2	2024-11-18 12:20:14.151157
865	10	2	2024-11-18 12:20:14.151157
866	60	2	2024-11-18 12:20:14.151157
867	59	2	2024-11-18 12:20:14.151157
868	61	1	2024-11-18 12:20:14.151157
869	62	2	2024-11-18 12:20:14.151157
870	63	2	2024-11-18 12:20:14.151157
871	64	2	2024-11-18 12:20:14.151157
872	65	1	2024-11-18 12:20:14.151157
873	67	2	2024-11-18 12:20:14.151157
874	68	2	2024-11-18 12:20:14.151157
\.


--
-- Data for Name: domain; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.domain (id, description, created_at) FROM stdin;
13	Devices	2023-10-06 14:55:04.836871
14	Apps & Workloads	2023-10-06 14:55:22.032712
17	Identity	2023-10-06 14:56:00.614473
18	Cross-Cutting ZTA	2023-10-06 14:56:13.832703
1	Infrastructure	2023-01-05 12:04:58.133484
2	Data	2023-01-05 12:04:58.145907
3	Application	2023-01-05 12:04:58.147519
5	Visibility	2023-01-05 12:04:58.151347
4	Networks	2023-01-05 12:04:58.149359
16	Networks ZTA	2023-10-06 14:55:48.372071
15	Data ZTA	2023-10-06 14:55:35.744453
20	ID.AM	2024-11-18 07:53:05.248986
21	ID.BE	2024-11-18 07:53:10.033697
23	ID.RA	2024-11-18 07:53:30.251179
24	ID.SC	2024-11-18 07:53:39.552142
25	PR.AC	2024-11-18 07:53:47.517283
26	PR.AT	2024-11-18 07:53:53.983982
27	PR.IP	2024-11-18 07:54:00.605649
28	PR.MA	2024-11-18 07:54:06.030345
29	PR.PT	2024-11-18 07:54:13.779933
30	DE.AE	2024-11-18 07:54:21.920627
31	DE.CM	2024-11-18 07:54:27.862637
32	DE.DP	2024-11-18 07:54:33.278373
33	RS.RP	2024-11-18 07:54:39.835292
34	RS.CO	2024-11-18 07:54:44.536935
35	RS.AN	2024-11-18 07:54:52.010597
36	RS.MI	2024-11-18 07:54:57.527111
37	RS.IM	2024-11-18 07:55:02.435894
38	RC.RP	2024-11-18 07:55:09.38697
39	RC.IM	2024-11-18 07:55:15.612763
40	RC.CO	2024-11-18 07:55:20.159939
41	ID.RM	2024-11-18 08:04:17.569688
42	ID.GV	2024-11-18 08:04:27.72672
43	PR.DS	2024-11-18 08:07:53.257189
44	Identity	2024-11-18 12:20:56.34124
\.


--
-- Data for Name: flag; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.flag (id, description, created_at) FROM stdin;
1	red	2023-01-05 12:06:10.998784
2	green	2023-01-05 12:06:17.838214
\.


--
-- Data for Name: integration_methods; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.integration_methods (integration_method_name, id) FROM stdin;
telescopeComplianceRhacs	1
telescopeSecureProtocols	6
telescopeTestApi	11
\.


--
-- Data for Name: integrations; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.integrations (integration_id, capability_id, url, "user", password, token, success_criteria, last_update, integration_name, integration_method_id, hash) FROM stdin;
23	1	https://www.chrisj.co.uk/stub				1	\N	Secure Images	\N	6ZFRW
24	133	https://www.chrisj.co.uk/stub				1	\N	SIEM	\N	URFYP
25	59	https://www.chrisj.co.uk/stub				1	\N	SAST	\N	K8JGS
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: telescope
--

COPY public.profiles (id, name, description, domains) FROM stdin;
2	ZTA	ZTA domains	{13,14,15,16,17,18}
1	Core	Default domains	{1,2,3,4,5}
22	NIST CSF	\N	{30,31,32,20,21,42,23,41,24,25,26,43,27,28,29,40,39,38,35,34,37,36,33}
\.


--
-- Name: capability_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.capability_history_id_seq', 874, true);


--
-- Name: capability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.capability_id_seq', 159, true);


--
-- Name: domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.domain_id_seq', 44, true);


--
-- Name: flag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.flag_id_seq', 2, true);


--
-- Name: integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.integration_id_seq', 25, true);


--
-- Name: integration_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.integration_methods_id_seq', 11, true);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: telescope
--

SELECT pg_catalog.setval('public.profiles_id_seq', 22, true);


--
-- Name: capability capability_pkey; Type: CONSTRAINT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.capability
    ADD CONSTRAINT capability_pkey PRIMARY KEY (id);


--
-- Name: domain domain_pkey; Type: CONSTRAINT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (id);


--
-- Name: flag flag_pkey; Type: CONSTRAINT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.flag
    ADD CONSTRAINT flag_pkey PRIMARY KEY (id);


--
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: telescope
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (integration_id);


--
-- Name: capability capability_trigger_copy; Type: TRIGGER; Schema: public; Owner: telescope
--

CREATE TRIGGER capability_trigger_copy AFTER UPDATE ON public.capability FOR EACH ROW EXECUTE FUNCTION public.capability_history();


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO telescope;


--
-- PostgreSQL database dump complete
--

