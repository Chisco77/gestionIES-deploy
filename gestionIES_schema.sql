--
-- PostgreSQL database dump
--

\restrict fsBQ1eDEmFXANSiTGXokQBRhD6D7cAZgNgQbsbdUi4m9xRL0ybJAghhVajlcWVC

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: api_cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_cursos_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asuntos_permitidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asuntos_permitidos (
    id integer NOT NULL,
    uid character varying NOT NULL,
    fecha date NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.asuntos_permitidos OWNER TO postgres;

--
-- Name: asuntos_permitidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asuntos_permitidos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asuntos_permitidos_id_seq OWNER TO postgres;

--
-- Name: asuntos_permitidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asuntos_permitidos_id_seq OWNED BY public.asuntos_permitidos.id;


--
-- Name: asuntos_propios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asuntos_propios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asuntos_propios_id_seq OWNER TO postgres;

--
-- Name: avisos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.avisos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.avisos_id_seq OWNER TO postgres;

--
-- Name: avisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avisos (
    id integer DEFAULT nextval('public.avisos_id_seq'::regclass) NOT NULL,
    modulo text NOT NULL,
    emails text[] NOT NULL,
    app_password character varying
);


ALTER TABLE public.avisos OWNER TO postgres;

--
-- Name: cursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cursos (
    id bigint NOT NULL,
    curso character varying NOT NULL
);


ALTER TABLE public.cursos OWNER TO postgres;

--
-- Name: cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cursos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: empleados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleados (
    uid character varying NOT NULL,
    tipo_usuario integer DEFAULT 0 NOT NULL,
    dni character varying NOT NULL,
    asuntos_propios integer NOT NULL,
    tipo_empleado character varying NOT NULL,
    jornada integer DEFAULT 0 NOT NULL,
    email character varying NOT NULL,
    telefono character varying NOT NULL
);


ALTER TABLE public.empleados OWNER TO postgres;

--
-- Name: estancias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estancias (
    id integer NOT NULL,
    planta text NOT NULL,
    codigo text NOT NULL,
    descripcion text NOT NULL,
    totalllaves integer DEFAULT 1 NOT NULL,
    coordenadas_json jsonb NOT NULL,
    armario character varying NOT NULL,
    codigollave character varying NOT NULL,
    reservable boolean DEFAULT false NOT NULL,
    tipoestancia character varying,
    numero_ordenadores integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.estancias OWNER TO postgres;

--
-- Name: estancias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estancias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estancias_id_seq OWNER TO postgres;

--
-- Name: estancias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estancias_id_seq OWNED BY public.estancias.id;


--
-- Name: extraescolares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.extraescolares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extraescolares_id_seq OWNER TO postgres;

--
-- Name: extraescolares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extraescolares (
    id integer DEFAULT nextval('public.extraescolares_id_seq'::regclass) NOT NULL,
    uid character varying NOT NULL,
    gidnumber integer NOT NULL,
    cursos_gids integer[] NOT NULL,
    tipo character varying(20) NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    idperiodo_inicio bigint,
    idperiodo_fin bigint,
    estado smallint DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    responsables_uids character varying[] NOT NULL,
    ubicacion text NOT NULL,
    coords jsonb NOT NULL,
    erasmus boolean DEFAULT false NOT NULL
);


ALTER TABLE public.extraescolares OWNER TO postgres;

--
-- Name: libros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libros (
    id bigint NOT NULL,
    idcurso bigint NOT NULL,
    libro character varying NOT NULL
);


ALTER TABLE public.libros OWNER TO postgres;

--
-- Name: libros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.libros ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.libros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: perfiles_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfiles_usuario (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    perfil character varying(50) NOT NULL
);


ALTER TABLE public.perfiles_usuario OWNER TO postgres;

--
-- Name: perfiles_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perfiles_usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.perfiles_usuario_id_seq OWNER TO postgres;

--
-- Name: perfiles_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perfiles_usuario_id_seq OWNED BY public.perfiles_usuario.id;


--
-- Name: periodos_horarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periodos_horarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.periodos_horarios_id_seq OWNER TO postgres;

--
-- Name: periodos_horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periodos_horarios (
    id integer DEFAULT nextval('public.periodos_horarios_id_seq'::regclass) NOT NULL,
    nombre character varying NOT NULL,
    inicio time without time zone NOT NULL,
    fin time without time zone NOT NULL
);


ALTER TABLE public.periodos_horarios OWNER TO postgres;

--
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permisos (
    id integer DEFAULT nextval('public.asuntos_propios_id_seq'::regclass) NOT NULL,
    uid character varying NOT NULL,
    fecha date NOT NULL,
    descripcion text NOT NULL,
    estado integer DEFAULT 0 NOT NULL,
    tipo integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.permisos OWNER TO postgres;

--
-- Name: prestamos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamos (
    id bigint NOT NULL,
    uid character varying NOT NULL,
    esalumno boolean DEFAULT true,
    doc_compromiso integer DEFAULT 0,
    fechaentregadoc date,
    fecharecepciondoc date,
    iniciocurso boolean DEFAULT false NOT NULL
);


ALTER TABLE public.prestamos OWNER TO postgres;

--
-- Name: prestamos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.prestamos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prestamos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: prestamos_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prestamos_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prestamos_items_id_seq OWNER TO postgres;

--
-- Name: prestamos_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamos_items (
    id bigint DEFAULT nextval('public.prestamos_items_id_seq'::regclass) NOT NULL,
    idprestamo bigint NOT NULL,
    idlibro bigint NOT NULL,
    fechaentrega date,
    fechadevolucion date,
    devuelto boolean DEFAULT false NOT NULL,
    entregado boolean DEFAULT false NOT NULL
);


ALTER TABLE public.prestamos_items OWNER TO postgres;

--
-- Name: prestamos_llaves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamos_llaves (
    id integer NOT NULL,
    idestancia integer NOT NULL,
    unidades integer DEFAULT 1 NOT NULL,
    fechaentrega timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fechadevolucion timestamp with time zone,
    uid character varying NOT NULL,
    devuelta boolean NOT NULL
);


ALTER TABLE public.prestamos_llaves OWNER TO postgres;

--
-- Name: prestamos_llaves_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.prestamos_llaves ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prestamos_llaves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reservas_estancias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservas_estancias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservas_estancias_id_seq OWNER TO postgres;

--
-- Name: reservas_estancias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservas_estancias (
    id integer DEFAULT nextval('public.reservas_estancias_id_seq'::regclass) NOT NULL,
    idestancia bigint NOT NULL,
    idperiodo_inicio bigint NOT NULL,
    idperiodo_fin bigint NOT NULL,
    uid character varying NOT NULL,
    fecha date,
    descripcion text NOT NULL,
    idrepeticion integer
);


ALTER TABLE public.reservas_estancias OWNER TO postgres;

--
-- Name: reservas_estancias_repeticion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservas_estancias_repeticion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservas_estancias_repeticion_id_seq OWNER TO postgres;

--
-- Name: reservas_estancias_repeticion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservas_estancias_repeticion (
    id integer DEFAULT nextval('public.reservas_estancias_repeticion_id_seq'::regclass) NOT NULL,
    uid character varying(50) NOT NULL,
    profesor character varying(50) NOT NULL,
    idestancia integer NOT NULL,
    idperiodo_inicio integer NOT NULL,
    idperiodo_fin integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    fecha_desde date NOT NULL,
    fecha_hasta date NOT NULL,
    descripcion text,
    frecuencia character varying(10) NOT NULL,
    dias_semana integer[],
    CONSTRAINT reservas_estancias_repeticion_frecuencia_check CHECK (((frecuencia)::text = ANY (ARRAY[('diaria'::character varying)::text, ('semanal'::character varying)::text, ('mensual'::character varying)::text])))
);


ALTER TABLE public.reservas_estancias_repeticion OWNER TO postgres;

--
-- Name: restricciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restricciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restricciones_id_seq OWNER TO postgres;

--
-- Name: restricciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restricciones (
    id integer DEFAULT nextval('public.restricciones_id_seq'::regclass) NOT NULL,
    tipo character varying(255) NOT NULL,
    restriccion character varying(255) NOT NULL,
    descripcion character varying(255) NOT NULL,
    valor_num integer NOT NULL,
    valor_bool boolean NOT NULL,
    rangos_bloqueados_json jsonb
);


ALTER TABLE public.restricciones OWNER TO postgres;

--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: asuntos_permitidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asuntos_permitidos ALTER COLUMN id SET DEFAULT nextval('public.asuntos_permitidos_id_seq'::regclass);


--
-- Name: estancias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estancias ALTER COLUMN id SET DEFAULT nextval('public.estancias_id_seq'::regclass);


--
-- Name: perfiles_usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfiles_usuario ALTER COLUMN id SET DEFAULT nextval('public.perfiles_usuario_id_seq'::regclass);


--
-- Name: asuntos_permitidos asuntos_permitidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asuntos_permitidos
    ADD CONSTRAINT asuntos_permitidos_pkey PRIMARY KEY (id);


--
-- Name: asuntos_permitidos asuntos_permitidos_uid_fecha_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asuntos_permitidos
    ADD CONSTRAINT asuntos_permitidos_uid_fecha_key UNIQUE (uid, fecha);


--
-- Name: permisos asuntos_propios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT asuntos_propios_pkey PRIMARY KEY (id);


--
-- Name: avisos avisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avisos
    ADD CONSTRAINT avisos_pkey PRIMARY KEY (id);


--
-- Name: cursos cursos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);


--
-- Name: estancias estancias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estancias
    ADD CONSTRAINT estancias_pkey PRIMARY KEY (id);


--
-- Name: extraescolares extraescolares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extraescolares
    ADD CONSTRAINT extraescolares_pkey PRIMARY KEY (id);


--
-- Name: libros libros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_pkey PRIMARY KEY (id);


--
-- Name: perfiles_usuario perfiles_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfiles_usuario
    ADD CONSTRAINT perfiles_usuario_pkey PRIMARY KEY (id);


--
-- Name: perfiles_usuario perfiles_usuario_uid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfiles_usuario
    ADD CONSTRAINT perfiles_usuario_uid_key UNIQUE (uid);


--
-- Name: periodos_horarios periodos_horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodos_horarios
    ADD CONSTRAINT periodos_horarios_pkey PRIMARY KEY (id);


--
-- Name: prestamos_items prestamos_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos_items
    ADD CONSTRAINT prestamos_items_pkey PRIMARY KEY (id);


--
-- Name: prestamos_llaves prestamos_llaves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos_llaves
    ADD CONSTRAINT prestamos_llaves_pkey PRIMARY KEY (id);


--
-- Name: prestamos prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (id);


--
-- Name: reservas_estancias reservas_estancias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_estancias
    ADD CONSTRAINT reservas_estancias_pkey PRIMARY KEY (id);


--
-- Name: reservas_estancias_repeticion reservas_estancias_repeticion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_estancias_repeticion
    ADD CONSTRAINT reservas_estancias_repeticion_pkey PRIMARY KEY (id);


--
-- Name: restricciones restricciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restricciones
    ADD CONSTRAINT restricciones_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: empleados usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (uid);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: permisos_uid_fecha_tipo_uk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permisos_uid_fecha_tipo_uk ON public.permisos USING btree (uid, fecha, tipo);


--
-- Name: prestamos_llaves prestamos_llaves_idestancia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos_llaves
    ADD CONSTRAINT prestamos_llaves_idestancia_fkey FOREIGN KEY (idestancia) REFERENCES public.estancias(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict fsBQ1eDEmFXANSiTGXokQBRhD6D7cAZgNgQbsbdUi4m9xRL0ybJAghhVajlcWVC

