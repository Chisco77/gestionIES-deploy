--
-- PostgreSQL database dump
--

\restrict ItgIYxPbnucZ1fvPtXH12x93maUAICJDFlL7eLTr3mRhuR7wnjmgpXUPeHPrnZI

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: actualizar_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.actualizar_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at := now();
   RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_tokens (
    nombre character varying NOT NULL,
    token character varying NOT NULL,
    rol character varying NOT NULL,
    id bigint NOT NULL
);


--
-- Name: api_cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asuntos_permitidos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asuntos_permitidos (
    id integer NOT NULL,
    uid character varying NOT NULL,
    fecha date NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: asuntos_permitidos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.asuntos_permitidos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asuntos_permitidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.asuntos_permitidos_id_seq OWNED BY public.asuntos_permitidos.id;


--
-- Name: asuntos_propios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.asuntos_propios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ausencias_profesorado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ausencias_profesorado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ausencias_profesorado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ausencias_profesorado (
    id bigint DEFAULT nextval('public.ausencias_profesorado_id_seq'::regclass) NOT NULL,
    uid_profesor character varying(50) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    idperiodo_inicio integer,
    idperiodo_fin integer,
    tipo_ausencia character varying(100),
    creada_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    creada_por character varying(50),
    idpermiso bigint,
    idextraescolar bigint,
    descripcion character varying,
    observaciones_guardia text,
    CONSTRAINT chk_fechas_validas CHECK (((fecha_fin IS NULL) OR (fecha_fin >= fecha_inicio)))
);


--
-- Name: avisos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.avisos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: avisos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.avisos (
    id integer DEFAULT nextval('public.avisos_id_seq'::regclass) NOT NULL,
    modulo text NOT NULL,
    emails text[] NOT NULL,
    app_password character varying
);


--
-- Name: configuracion_centro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configuracion_centro (
    id integer NOT NULL,
    nombre_ies character varying(255) NOT NULL,
    direccion_linea_1 character varying(255),
    direccion_linea_2 character varying(255),
    direccion_linea_3 character varying(255),
    telefono character varying(20),
    fax character varying(20),
    email character varying(150),
    localidad character varying(100) DEFAULT 'Trujillo'::character varying,
    provincia character varying(100) DEFAULT 'Cáceres'::character varying,
    codigo_postal character varying(10),
    web_url character varying(255),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
    logo_miies_url text COLLATE pg_catalog."default",
    logo_centro_url text COLLATE pg_catalog."default"
);


--
-- Name: configuracion_centro_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configuracion_centro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configuracion_centro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configuracion_centro_id_seq OWNED BY public.configuracion_centro.id;


--
-- Name: cursos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cursos (
    id bigint NOT NULL,
    curso character varying NOT NULL
);


--
-- Name: cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: empleados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.empleados (
    uid character varying NOT NULL,
    tipo_usuario integer DEFAULT 0 NOT NULL,
    dni character varying NOT NULL,
    asuntos_propios integer NOT NULL,
    tipo_empleado character varying NOT NULL,
    jornada integer DEFAULT 0 NOT NULL,
    email character varying NOT NULL,
    telefono character varying NOT NULL,
    cuerpo character varying,
    grupo character varying,
    personal character varying,
    baja boolean DEFAULT false NOT NULL
);


--
-- Name: estancias; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: estancias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estancias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estancias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estancias_id_seq OWNED BY public.estancias.id;


--
-- Name: extraescolares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.extraescolares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: extraescolares; Type: TABLE; Schema: public; Owner: -
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
    erasmus boolean DEFAULT false NOT NULL,
    updated_by character varying,
    genera_ausencias boolean DEFAULT true NOT NULL
);


--
-- Name: guardias_asignadas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.guardias_asignadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guardias_asignadas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guardias_asignadas (
    id bigint DEFAULT nextval('public.guardias_asignadas_id_seq'::regclass) NOT NULL,
    fecha date NOT NULL,
    idperiodo integer NOT NULL,
    uid_profesor_ausente character varying(50) NOT NULL,
    uid_profesor_cubridor character varying(50) NOT NULL,
    forzada boolean DEFAULT false,
    generada_automaticamente boolean DEFAULT true,
    uid_asignador character varying(50),
    estado character varying(20) DEFAULT 'activa'::character varying,
    confirmada boolean DEFAULT true,
    creada_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    idausencia integer NOT NULL
);


--
-- Name: horario_profesorado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horario_profesorado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horario_profesorado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horario_profesorado (
    id bigint DEFAULT nextval('public.horario_profesorado_id_seq'::regclass) NOT NULL,
    uid character varying(50) NOT NULL,
    dia_semana integer NOT NULL,
    idperiodo integer NOT NULL,
    tipo character varying(30) NOT NULL,
    gidnumber integer[],
    idmateria bigint,
    idestancia integer,
    curso_academico character varying(9) NOT NULL,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT horario_profesorado_dia_semana_check CHECK (((dia_semana >= 1) AND (dia_semana <= 5)))
);


--
-- Name: libros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.libros (
    id bigint NOT NULL,
    idcurso bigint NOT NULL,
    libro character varying NOT NULL,
    idmateria bigint
);


--
-- Name: libros_id_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: materias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.materias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.materias (
    id bigint DEFAULT nextval('public.materias_id_seq'::regclass) NOT NULL,
    nombre character varying(255) NOT NULL,
    creada_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: perfiles_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perfiles_usuario (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    perfil character varying(50) NOT NULL
);


--
-- Name: perfiles_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.perfiles_usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: perfiles_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.perfiles_usuario_id_seq OWNED BY public.perfiles_usuario.id;


--
-- Name: periodos_horarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.periodos_horarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: periodos_horarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.periodos_horarios (
    id integer DEFAULT nextval('public.periodos_horarios_id_seq'::regclass) NOT NULL,
    nombre character varying NOT NULL,
    inicio time without time zone NOT NULL,
    fin time without time zone NOT NULL
);


--
-- Name: permisos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permisos (
    id integer DEFAULT nextval('public.asuntos_propios_id_seq'::regclass) NOT NULL,
    uid character varying NOT NULL,
    fecha date NOT NULL,
    descripcion text NOT NULL,
    estado integer DEFAULT 0 NOT NULL,
    tipo integer,
    created_at timestamp with time zone DEFAULT now(),
    idperiodo_inicio integer,
    idperiodo_fin integer,
    dia_completo boolean DEFAULT true NOT NULL,
    fecha_fin date,
    uid_ultimo_procesado character varying(255),
    fecha_ultimo_procesado timestamp with time zone
);


--
-- Name: prestamos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: prestamos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: prestamos_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prestamos_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prestamos_items; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: prestamos_llaves; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: prestamos_llaves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
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
-- Name: reservas_estancias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservas_estancias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservas_estancias; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: reservas_estancias_repeticion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservas_estancias_repeticion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservas_estancias_repeticion; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: restricciones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.restricciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: restricciones; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: asuntos_permitidos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asuntos_permitidos ALTER COLUMN id SET DEFAULT nextval('public.asuntos_permitidos_id_seq'::regclass);


--
-- Name: configuracion_centro id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_centro ALTER COLUMN id SET DEFAULT nextval('public.configuracion_centro_id_seq'::regclass);


--
-- Name: estancias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estancias ALTER COLUMN id SET DEFAULT nextval('public.estancias_id_seq'::regclass);


--
-- Name: perfiles_usuario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfiles_usuario ALTER COLUMN id SET DEFAULT nextval('public.perfiles_usuario_id_seq'::regclass);


--
-- Name: access_tokens access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: asuntos_permitidos asuntos_permitidos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asuntos_permitidos
    ADD CONSTRAINT asuntos_permitidos_pkey PRIMARY KEY (id);


--
-- Name: asuntos_permitidos asuntos_permitidos_uid_fecha_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asuntos_permitidos
    ADD CONSTRAINT asuntos_permitidos_uid_fecha_key UNIQUE (uid, fecha);


--
-- Name: permisos asuntos_propios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT asuntos_propios_pkey PRIMARY KEY (id);


--
-- Name: ausencias_profesorado ausencias_profesorado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ausencias_profesorado
    ADD CONSTRAINT ausencias_profesorado_pkey PRIMARY KEY (id);


--
-- Name: avisos avisos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avisos
    ADD CONSTRAINT avisos_pkey PRIMARY KEY (id);


--
-- Name: configuracion_centro configuracion_centro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_centro
    ADD CONSTRAINT configuracion_centro_pkey PRIMARY KEY (id);


--
-- Name: cursos cursos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);


--
-- Name: estancias estancias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estancias
    ADD CONSTRAINT estancias_pkey PRIMARY KEY (id);


--
-- Name: extraescolares extraescolares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extraescolares
    ADD CONSTRAINT extraescolares_pkey PRIMARY KEY (id);


--
-- Name: guardias_asignadas guardias_asignadas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardias_asignadas
    ADD CONSTRAINT guardias_asignadas_pkey PRIMARY KEY (id);


--
-- Name: horario_profesorado horario_profesorado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horario_profesorado
    ADD CONSTRAINT horario_profesorado_pkey PRIMARY KEY (id);


--
-- Name: libros libros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_pkey PRIMARY KEY (id);


--
-- Name: materias materias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materias
    ADD CONSTRAINT materias_pkey PRIMARY KEY (id);


--
-- Name: perfiles_usuario perfiles_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfiles_usuario
    ADD CONSTRAINT perfiles_usuario_pkey PRIMARY KEY (id);


--
-- Name: perfiles_usuario perfiles_usuario_uid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perfiles_usuario
    ADD CONSTRAINT perfiles_usuario_uid_key UNIQUE (uid);


--
-- Name: periodos_horarios periodos_horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periodos_horarios
    ADD CONSTRAINT periodos_horarios_pkey PRIMARY KEY (id);


--
-- Name: prestamos_items prestamos_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos_items
    ADD CONSTRAINT prestamos_items_pkey PRIMARY KEY (id);


--
-- Name: prestamos_llaves prestamos_llaves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos_llaves
    ADD CONSTRAINT prestamos_llaves_pkey PRIMARY KEY (id);


--
-- Name: prestamos prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (id);


--
-- Name: reservas_estancias reservas_estancias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservas_estancias
    ADD CONSTRAINT reservas_estancias_pkey PRIMARY KEY (id);


--
-- Name: reservas_estancias_repeticion reservas_estancias_repeticion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservas_estancias_repeticion
    ADD CONSTRAINT reservas_estancias_repeticion_pkey PRIMARY KEY (id);


--
-- Name: restricciones restricciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restricciones
    ADD CONSTRAINT restricciones_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: ausencias_profesorado unique_extraescolar_profesor; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ausencias_profesorado
    ADD CONSTRAINT unique_extraescolar_profesor UNIQUE (idextraescolar, uid_profesor);


--
-- Name: empleados usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (uid);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: horario_profesorado_guardia_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX horario_profesorado_guardia_unique ON public.horario_profesorado USING btree (uid, dia_semana, idperiodo, curso_academico) WHERE ((tipo)::text = 'guardia'::text);


--
-- Name: idx_ausencias_profesor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ausencias_profesor ON public.ausencias_profesorado USING btree (uid_profesor);


--
-- Name: idx_ausencias_rango; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ausencias_rango ON public.ausencias_profesorado USING btree (fecha_inicio, fecha_fin);


--
-- Name: idx_guardias_ausente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guardias_ausente ON public.guardias_asignadas USING btree (uid_profesor_ausente);


--
-- Name: idx_guardias_cubridor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guardias_cubridor ON public.guardias_asignadas USING btree (uid_profesor_cubridor);


--
-- Name: idx_guardias_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guardias_estado ON public.guardias_asignadas USING btree (estado);


--
-- Name: idx_guardias_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guardias_fecha ON public.guardias_asignadas USING btree (fecha);


--
-- Name: idx_guardias_fecha_periodo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guardias_fecha_periodo ON public.guardias_asignadas USING btree (fecha, idperiodo);


--
-- Name: idx_horario_curso; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_horario_curso ON public.horario_profesorado USING btree (curso_academico);


--
-- Name: idx_horario_dia_periodo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_horario_dia_periodo ON public.horario_profesorado USING btree (dia_semana, idperiodo);


--
-- Name: idx_horario_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_horario_uid ON public.horario_profesorado USING btree (uid);


--
-- Name: idx_horario_uid_dia_curso; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_horario_uid_dia_curso ON public.horario_profesorado USING btree (uid, dia_semana, curso_academico);


--
-- Name: permisos_uid_fecha_tipo_uk; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX permisos_uid_fecha_tipo_uk ON public.permisos USING btree (uid, fecha, tipo);


--
-- Name: uq_ausencias_idpermiso; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_ausencias_idpermiso ON public.ausencias_profesorado USING btree (idpermiso);


--
-- Name: extraescolares trigger_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_updated_at BEFORE UPDATE ON public.extraescolares FOR EACH ROW EXECUTE FUNCTION public.actualizar_updated_at();


--
-- Name: ausencias_profesorado ausencias_profesorado_idperiodo_fin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ausencias_profesorado
    ADD CONSTRAINT ausencias_profesorado_idperiodo_fin_fkey FOREIGN KEY (idperiodo_fin) REFERENCES public.periodos_horarios(id);


--
-- Name: ausencias_profesorado ausencias_profesorado_idperiodo_inicio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ausencias_profesorado
    ADD CONSTRAINT ausencias_profesorado_idperiodo_inicio_fkey FOREIGN KEY (idperiodo_inicio) REFERENCES public.periodos_horarios(id);


--
-- Name: guardias_asignadas fk_guardias_ausencia; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardias_asignadas
    ADD CONSTRAINT fk_guardias_ausencia FOREIGN KEY (idausencia) REFERENCES public.ausencias_profesorado(id) ON DELETE CASCADE;


--
-- Name: guardias_asignadas guardias_asignadas_idperiodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardias_asignadas
    ADD CONSTRAINT guardias_asignadas_idperiodo_fkey FOREIGN KEY (idperiodo) REFERENCES public.periodos_horarios(id);


--
-- Name: horario_profesorado horario_profesorado_idmateria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horario_profesorado
    ADD CONSTRAINT horario_profesorado_idmateria_fkey FOREIGN KEY (idmateria) REFERENCES public.materias(id);


--
-- Name: horario_profesorado horario_profesorado_idperiodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horario_profesorado
    ADD CONSTRAINT horario_profesorado_idperiodo_fkey FOREIGN KEY (idperiodo) REFERENCES public.periodos_horarios(id);


--
-- Name: prestamos_llaves prestamos_llaves_idestancia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos_llaves
    ADD CONSTRAINT prestamos_llaves_idestancia_fkey FOREIGN KEY (idestancia) REFERENCES public.estancias(id) ON DELETE CASCADE;



-- Registro inicial: perfil administrador -- ------------------------------------------------------------ 
INSERT INTO public.perfiles_usuario (uid, perfil) SELECT 'admin', 'administrador' WHERE NOT EXISTS ( SELECT 1 FROM public.perfiles_usuario WHERE uid = 'admin' );

-- ------------------------------------------------------------
-- Registro inicial: Periodos Horarios por defecto
-- ------------------------------------------------------------

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '1ª Hora', '08:30:00', '09:20:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '1ª Hora');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '2ª Hora', '09:20:00', '10:15:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '2ª Hora');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '3ª Hora', '10:15:00', '11:10:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '3ª Hora');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT 'Recreo', '11:10:00', '11:40:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = 'Recreo');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '4ª Hora', '11:40:00', '12:30:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '4ª Hora');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '5ª Hora', '12:30:00', '13:25:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '5ª Hora');

INSERT INTO public.periodos_horarios (nombre, inicio, fin)
SELECT '6ª Hora', '13:25:00', '14:20:00' WHERE NOT EXISTS (SELECT 1 FROM public.periodos_horarios WHERE nombre = '6ª Hora');


-- ------------------------------------------------------------
-- Registro inicial: Configuración del centro
-- ------------------------------------------------------------
INSERT INTO public.configuracion_centro (
    nombre_ies,
    direccion_linea_1,
    direccion_linea_2,
    direccion_linea_3,
    telefono,
    fax,
    email,
    localidad,
    provincia,
    codigo_postal,
    web_url,
    logo_url,
    updated_at,
    logo_miies_url,
    logo_centro_url
)
SELECT
    'IES Francisco de Orellana',
    'Secretaría General de Educación y F.P.',
    'Avda. Reina Mª Cristina, s/n.',
    'Apdo. De Correos n.º 17',
    '927027790',
    '927027789',
    'ies.franciscodeorellana@edu.juntaex.es',
    'Trujillo',
    'Cáceres',
    NULL,
    NULL,
    NULL,
    CURRENT_TIMESTAMP,
    NULL,
    NULL
WHERE NOT EXISTS (
    SELECT 1
    FROM public.configuracion_centro
    WHERE nombre_ies = 'IES Francisco de Orellana'
);
--
-- PostgreSQL database dump complete
--

\unrestrict ItgIYxPbnucZ1fvPtXH12x93maUAICJDFlL7eLTr3mRhuR7wnjmgpXUPeHPrnZI