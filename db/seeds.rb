# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#  cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#  Mayor.create(name: 'Emanuel', city: cities.first)

#Cuestionarios
ProcessArea.create(id: 1, name: 'Planificación de Proyectos', description: 'Un área de proceso de Gestión de Proyectos en el nivel de madurez 2', purpose: 'El propósito de la Planificación del Proyecto (PP) es establecer y mantener
planes que definan las actividades del proyecto.')

#Specifics Goals
SpecificGoal.create(id: 1, name: 'Establecer las estimaciones', description: '', process_areas_id: 1)
SpecificGoal.create(id: 2, name: 'Desarrollar un plan del proyecto', description: '', process_areas_id: 1)
SpecificGoal.create(id: 3, name: 'Obtener el compromiso con el plan', description: '', process_areas_id: 1)

#SpecificGoal #1
Practice.create(id:1, name: 'Estimar el alcance del proyecto', question: '¿Se estima el alcance del proyecto?', examples: 'Ejemplo: Establecer un WBS (Estructura de descomposición de trabajo) para estimar el alcance del proyecto.', necessary: 0, specific_goals_id: 1)
Practice.create(id:2, name: 'Establecer las estimaciones de los atributos de los productos de trabajo y de las tareas', question: '¿Se establecen las estimaciones de los atributos de los productos de trabajo y de las tareas?', examples: 'Ejemplos de atributos para estimar son:
* Número y complejidad de los requisitos.
* Número y complejidad de las interfaces.
* Número de funciones.
* Puntos función.
* Líneas de código fuente.', necessary: 0, specific_goals_id: 1)
Practice.create(id:3, name: 'Definir las fases del ciclo de vida del proyecto', question: '¿Se definen las fases del ciclo de vida del proyecto?', examples: 'Ejemplo de productos de trabajo: Fases del ciclo de vida del proyecto.', necessary: 0, specific_goals_id: 1)
Practice.create(id:4, name: 'Estimar el esfuerzo y el coste', question: '¿Se estima el esfuerzo y coste?', examples: 'Ejemplos de productos de trabajo:
* Análisis razonado de la estimación.
* Estimaciones del esfuerzo del proyecto.
* Estimaciones del coste del proyecto.', necessary: 1, specific_goals_id: 1)

#SpecificGoal #2
Practice.create(id:5, name: 'Establecer el presupuesto y el calendario', question: '¿Se establece el presupuesto y el calendario? ', examples: 'Ejemplo de productos de trabajo: Fases del ciclo de vida del proyecto.', necessary: 0, specific_goals_id: 2)
Practice.create(id:6, name: 'Identificar los riesgos del proyecto', question: '¿Se identifican los riesgos del proyecto? ', examples: 'Ejemplo de productos de trabajo:
* Riesgos identificados
* Impactos y probabilidad de ocurrencia de los riesgos
* Prioridades de los riesgo ', necessary: 0, specific_goals_id: 2)
Practice.create(id:7, name: 'Planificar la gestión de los datos', question: '¿Se planifica la gestión de los datos del proyecto?', examples: 'Ejemplo de productos de trabajo:
* Plan para la gestión de datos
* Lista maestra de datos gestionados
* Calendario para la recogida de datos del proyecto
* Listado de datos del proyecto a recoger', necessary: 0, specific_goals_id: 2)
Practice.create(id:8, name: 'Planificar los recursos del proyecto', question: '¿Se planifican los recursos del proyecto?', examples: 'Ejemplo de productos de trabajo:
* Paquetes de trabajo.
* Diccionario de tareas de la WBS.
* Requisitos de personal basados en el tamaño y el alcance del proyecto.
* Lista de instalaciones y equipamientos críticos.
* Lista de requisitos de administración del proyecto. ', necessary: 0, specific_goals_id: 2)
Practice.create(id:9, name: 'Planificar el conocimiento y las habilidades necesarias', question: 'Se planifica el conocimiento y las habilidades necesarias? ', examples: 'Ejemplo de productos de trabajo:
* Inventario de habilidades necesarias.
* Planes de personal y nuevas contrataciones.
* Bases de datos (p. ej., habilidades, formación).
* Planes de formación.', necessary: 0, specific_goals_id: 2)
Practice.create(id:10, name: 'Planificar la involucración de las partes interesadas', question: '¿Se planifica la involucración de las partes interesadas? ', examples: 'Ejemplo de productos de trabajo: Plan para la involucración de las partes interesadas', necessary: 0, specific_goals_id: 2)
Practice.create(id:11, name: 'Establecer el plan de proyecto', question: '¿Se establece el plan del proyecto? ', examples: 'Ejemplo de productos de trabajo: Plan global del proyecto', necessary: 1, specific_goals_id: 2)

#SpecificGoal #3
Practice.create(id:12, name: 'Revisar los planes que afectan al proyecto', question: '¿Se revisan los planes que afectan al proyecto?', examples: 'Ejemplo de productos de trabajo: Registro de la revisiones de los planes que afectan al proyecto.', necessary: 0, specific_goals_id: 3)
Practice.create(id:13, name: 'Conciliar los niveles de trabajo y de recursos', question: '¿Se concilian los niveles de trabajo y de recursos?', examples: 'Ejemplo de productos de trabajo:
* Métodos y parámetros de estimación correspondientes modificados (p. ej., mejores herramientas, uso de productos comerciales).
* Presupuestos renegociados.
* Calendarios modificados.
* Lista de requisitos modificada.', necessary: 0, specific_goals_id: 3)
Practice.create(id:14, name: 'Obtener el compromiso con el plan', question: '¿Se obtiene un compromiso con el plan?', examples: 'Ejemplo de productos de trabajo:
* Peticiones de compromisos documentadas.
* Compromisos documentados. ', necessary: 1, specific_goals_id: 3)


#Scrum Practices
ScrumPractice.create(practice_id:1, supported: 0, name:'No soportada', description: 'En Scrum el WBS se compone de Product Backlog y de los Sprints predefinidos, sin embargo, el Producto Backlog es elaborado por el cliente y presentado por el Product Owner, sin presentar guías sobre cómo se éste se crea.')
ScrumPractice.create(practice_id:2, supported: 2, name:'Estimar atributos mediante Planning Poker o Magic Estimation', description: 'Scrum establece una primera estimación en la fase pre-game y una estimación iterativa al principio del sprint (reunión de planificación). Las estimaciones se basan generalmente en tamaño o complejidad atributos',
  meeting:"Estimation meeting", ingredients:'* El Product Backlog, el cual es priorizado por el Product Owner de acuerdo con el valor del negocio.
* Tarjetas numeradas Planing  Poker o Magic Estimation.',
  procedure: '1. El Product Owner presenta los ítems del Product Backlog que necesitan se estimados por el Equipo.
2. El equipo utiliza Planning Poker or Magic Estimation para estimar los items del Backlog.
3. En caso de que un ítem sea muy largo, el equipo lo dividirá en ítems más pequeños.
4. Vuelva a calcular todos los ítems del Backlog que puedan ser jalados durante los siguientes tres Sprints.
5. Identifica los ítems del Backlog que necesitan ser aclarados por el Product Owner hasta la siguiente reunión de estimación.',
  duration: 'Fijar el tiempo a 35 minutos o menos', techniques: 'Planning Poker, Magic Estimation')
ScrumPractice.create(practice_id:3, supported: 2, name:'Utilizar el ciclo de vida de Scrum ', description: 'El ciclo de vida de Scrum se compone de 4 fases (Larman, 2004):
Planning: Establece una visión del proyecto y las expectativas de los interesados, más allá de asegurar la financiación / presupuesto para la ejecución del proyecto.
Staging: Identifica y prioriza los requisitos (al menos, para el siguiente sprint). Divide el Product Backlog en Sprints de acuerdo con la priorización anterior, teniendo en cuenta la productividad del equipo.
Development: Implementa el sistema en un conjunto de iteraciones de 30 días (Sprints), cuando, al final de cada sprint, un incremento del producto se presenta a las partes interesadas.
Release: Despliegue del sistema.')
ScrumPractice.create(practice_id:4, supported: 1, name:'Estimar el esfuerzo de las historias de usuario', description: 'Los practicantes de Scrum estiman el esfuerzo de las historias de usuario en días basándose en sprints previos, proyectos anteriores y la complejidad relativa de las historias de usuario.
El costo no se menciona explícitamente en SCRUM, por lo cual esta práctica es parcialmente soportada.',
  meeting:'Sprint Planning Meeting #1', ingredients:'* El Product Backlog estimado y pririzado.
* Rotafolios, marcadores, tijeras, notas adhesivas, pizarras, lápices, etc.', procedure: '1. Comenzar con el primer ítem del Product Backlog (Historia).
2. El equipo discute y analiza los requerimientos de la historia.
3. El equipo elabora las pruebas de aceptación de usuario.
4. Anotar las restricciones.
5. Definir los criterios de aceptación.
6. Determinar el nivel de Hecho para la historia.
7. Dibujar bocetos de las funcionalidades de la historia.
8. Para el siguiente ítem del Backlog, regresar al paso 1.', duration: '60 minutos por semana de Sprint.', tools:'- Burn down chart
- Burn up chart')
ScrumPractice.create(practice_id:5, supported: 1, name:'Establecer Sprints', description: 'Durante la fase pre-game  se establecen hitos (objetivos del sprint) y calendarios (sprints) de acuerdo al Backlog inicial.
Por otra parte, Scrum no provee orientaciones sobre el establecimiento de presupuesto, por lo cual esta práctica es parcialmente soportada.',
meeting:'Sprint Planning Meeting #2', ingredients: '* El Product Backlog seleccionado para el Sprint.
* Rotafolios, marcadores, tijeras, notas adhesivas, pizarras, lápices, etc.', procedure: '1. Comenzar con el primer ítem del Product Backlog.
2. Recapitular la comprensión del equipo de lo que es realmente deseado examinado los rotafolios de reunión de planificación de Sprint # 1.
3. Ejecutar una discusión orientada a como podría ser implementado el ítem del Backlog.
  Estas preguntas pueden ayudar:
  a) ¿Qué interfaces necesitamos escribir?
  b) ¿Qué bases de datos necesitaremos?
  c) ¿Qué arquitectura es necesaria?
Una vez que el equipo tiene un claro entendimiento de la manera en la que desea construir una característica, se puede pasar al siguiente ítem del Backlog.', duration: '60 minutos por semana de Sprint')

ScrumPractice.create(practice_id:6, supported: 1, name:'Identificar lista de impedimentos', description: 'SCRUM considera un riesgo como un posible impedimento para el proyecto. La identificación de los riesgos se produce de forma iterativa, durante las reuniones diarias registrando en pizarras, rotafolios o la lista de impedimentos.
Sin embargo, la identificación de riesgos no se produce de una manera sistemática utilizando las categorías de riesgo y  sus fuentes. Por lo tanto, esta práctica es parcialmente soportada.',
meeting: 'Daily Scrum', ingredients: '* Taskboard (Tabla de tareas)
* Notas adhesivas
* Marcadores ', procedure: '1. El equipo se reúne alrededor del Taskboard.
2. Uno de los miembros del equipo comienza explicando a sus compañeros lo que ha logrado poner en práctica desde el última Scrum Diario.
3. El miembro del equipo mueve la tarea correspondiente en la columna correcta de la TaskBoard.
4. En su caso, el miembro del Equipo recoge una nueva tarea y la coloca en la columna "Work in Progress".
5. Si el miembro del equipo ha detectado un problema o impedimento desde el último Scrum Diario, lo reporta al ScrumMaster quien toma nota para la eliminación inmediata.', duration: '15 minutos, a la misma hora y ubicación todos los días')

ScrumPractice.create(practice_id:7, supported: 0, name:'No soportada', description: 'En Scrum cualquier dato generado en el proyecto se almacenan en carpetas públicas o pizarras al alcance de todos, pero no hay un plan de gestión de datos formal o procedimiento para recoger estos datos.')

ScrumPractice.create(practice_id:8, supported: 2, name:'Establecer el Equipo Scrum', description: 'Durante  la fase pre-game, los requerimientos de personal y la lista de equipamiento se definen. Como resultado se establece el Equipo Scrum. Durante la ejecución sprints, el ScrumMaster es el encargado de proporcionar nuevos recursos que sean necesarios.',
meeting:'Sprint Planning Meeting #2', ingredients: '* El Product Backlog seleccionado para el Sprint.
* Rotafolios, marcadores, tijeras, notas adhesivas, pizarras, lápices, etc.', procedure: '1. Comenzar con el primer ítem del Product Backlog.
2. Recapitular la comprensión del equipo de lo que es realmente deseado examinado los rotafolios de reunión de planificación de Sprint # 1.
3. Ejecutar una discusión orientada a como podría ser implementado el ítem del Backlog.
  Estas preguntas pueden ayudar:
  a) ¿Qué interfaces necesitamos escribir?
  b) ¿Qué bases de datos necesitaremos?
  c) ¿Qué arquitectura es necesaria?
Una vez que el equipo tiene un claro entendimiento de la manera en la que desea construir una característica, se puede pasar al siguiente ítem del Backlog.',
duration: '60 minutos por semana de Sprint')

ScrumPractice.create(practice_id:9, supported: 0, name:'No soportada', description: 'En Scrum los equipos son multifuncionales y auto-gestionados, el conocimiento y las habilidades necesarias se identifican durante la fase pre-game. Sin  embargo, Scrum no menciona la necesidad de planificar el conocimiento y habilidades necesarias para realizar las actividades del proyecto.')

ScrumPractice.create(practice_id:10, supported: 1, name:'Definir roles y responsabilidades al principio y fin del Sprint', description: 'Scrum define roles, responsabilidades y participación de las partes interesadas al principio y al final de cada sprint. Esta participación es supervisada por el Scrum Master y registrada en un plan de comunicación.')

ScrumPractice.create(practice_id:11, supported: 2, name:'Establecer el plan del proyecto con base en el Product Backlog', description: 'El documento de visión y el Producto Backlog crean una base para la elaboración de un plan de proyecto de alto nivel.
La visión describe por qué el proyecto se está realizando y lo cual es el estado final deseado. El Product Backlog define los requisitos funcionales y no funcionales que el sistema debe cumplir para entregar la visión, priorizados y estimados.',
meeting:'TaskBoard', tools: '- Taskboard: Ofrece una descripción visual de los ítems seleccionados del Product Backlog (historias) y el Sprint Backlog (tareas).
a) El taskboard sólo es mantenido por el equipo.
b) Nada vence la experiencia de usar un tablero físico en la pared o sala del equipo.
c) Si hay equipos de software distribuidos, un software para el taskboard le ayudará a mantener la comunicación entre distancias.',
procedure: 'Crear un tablero con las siguientes columnas:
1. Selected Product Backlog (Historias). Esta columna contiene todos los ítems del Backlog que el equipo desea implementar en el Sprint actual, en orden priorizado.
2. Task To Do. Son el resultado del Sprint Planning Meeting #2 o se han agregado durante el Sprint.
3. Work in Progress. Cuando un miembro del equipo inicia una tarea, se mueve la nota adhesiva de esta tarea a esta columna.
4. Done. Cuando se ha completado una tarea, se mueve la nota adhesiva a esta columna.')


ScrumPractice.create(practice_id:12, supported: 2, name:'Revisar los planes que afectan al proyecto en la revisión de Sprint', description: 'En Scrum, los planes se revisan al comienzo de cada sprint y las posibles adaptaciones se llevan a cabo conforme al cambio de requisitos y tecnologías.',
  meeting: 'Sprint Review', ingredients: '* Incremento del producto potencialmente entregable, presentado por el equipo.
* Taskboard, notas adhesivas, marcadores.', procedure: '1. El Product Owner da la bienvenida a los participantes del Sprint Review
2. El Product Owner les recuerda a los presentes el propósito del Sprint pasado: el objetivo del Sprint, el cual soporta las historias que el equipo había seleccionado.
3. Los miembros del equipo de desarrollo demuestran las nuevas funcionalidades y piden al usuario final que las prueben.
4. El Scrum Master modera la sesión.
5. La retroalimentación del usuario final es documentada por el ScrumMaster.', duration:'90 min. al final del Sprint')

ScrumPractice.create(practice_id:13, supported: 2, name:'Conciliar los niveles de trabajo y de recursos en la planificación de Sprints', description: 'Durante la reunión de planificación de Sprint se produce la conciliación de trabajo debido a que el Backlog es dinámico, por lo que son posibles nuevas estimaciones y calendarios.
El equipo, el Product Owner y el Scrum Master definen las funcionalidades que se desarrollarán en el Sprint.',
meeting:'Sprint Planning Meeting #2', ingredients: '* El Product Backlog seleccionado para el Sprint.
* Rotafolios, marcadores, tijeras, notas adhesivas, pizarras, lápices, etc.', procedure: '1. Comenzar con el primer ítem del Product Backlog.
2. Recapitular la comprensión del equipo de lo que es realmente deseado examinado los rotafolios de reunión de planificación de Sprint # 1.
3. Ejecutar una discusión orientada a como podría ser implementado el ítem del Backlog.
  Estas preguntas pueden ayudar:
  a) ¿Qué interfaces necesitamos escribir?
  b) ¿Qué bases de datos necesitaremos?
  c) ¿Qué arquitectura es necesaria?
Una vez que el equipo tiene un claro entendimiento de la manera en la que desea construir una característica, se puede pasar al siguiente ítem del Backlog.', duration: '60 minutos por semana de Sprint')

ScrumPractice.create(practice_id:14, supported: 2, name:'Obtener el compromiso con el plan durante la planificación de Sprints ', description: 'El compromiso del plan se produce de forma continua al comienzo de cada sprint, durante la reunión de planificación de Sprint. En ella el ScrumMaster pregunta al equipo si desea comprometerse con cada ítem del Product Backlog.',
meeting:'Sprint Planning Meeting #1', ingredients:'* El Product Backlog estimado y pririzado.
* Rotafolios, marcadores, tijeras, notas adhesivas, pizarras, lápices, etc.', procedure: '1. Comenzar con el primer ítem del Product Backlog (Historia).
2. El equipo discute y analiza los requerimientos de la historia.
3. El equipo elabora las pruebas de aceptación de usuario.
4. Anotar las restricciones.
5. Definir los criterios de aceptación.
6. Determinar el nivel de Hecho para la historia.
7. Dibujar bocetos de las funcionalidades de la historia.
8. Para el siguiente ítem del Backlog, regresar al paso 1.
Una vez elegidos los ítems que se van a desarrollar en el Sprint, el ScrumMaster le pregunta al equipo si se compromete a entregar dichos ítems.', duration: '60 minutos por semana de Sprint.')


##Técnicas y herramientas ligeras
#Practice 1
TechniqueTool.create(practice_id:1, name: "Juicio experto", complexity:0, approach:1)
TechniqueTool.create(practice_id:1, name: "COCOMO", complexity:2, approach:1)
TechniqueTool.create(practice_id:1, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:1, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:1, name: "Lorem ipsum dolor sit amet", complexity:2, approach:1)
TechniqueTool.create(practice_id:1, name: "Consectetur adipisicing elit", complexity:1, approach:1)
TechniqueTool.create(practice_id:1, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:1)

#Practica 2
TechniqueTool.create(practice_id:2, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:2, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:2, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:2, name: "Consectetur adipisicing elit", complexity:1, approach:0)
TechniqueTool.create(practice_id:2, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practice 3
TechniqueTool.create(practice_id:3, name: "Juicio experto", complexity:0, approach:1)
TechniqueTool.create(practice_id:3, name: "COCOMO", complexity:2, approach:1)
TechniqueTool.create(practice_id:3, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:3, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:3, name: "Lorem ipsum dolor sit amet", complexity:2, approach:1)
TechniqueTool.create(practice_id:3, name: "Consectetur adipisicing elit", complexity:1, approach:1)
TechniqueTool.create(practice_id:3, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:1)


#Practica 4
TechniqueTool.create(practice_id:4, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:4, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:4, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:4, name: "Lorem ipsum dolor sit amet", complexity:2, approach:0)
TechniqueTool.create(practice_id:4, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practica 5
TechniqueTool.create(practice_id:5, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:5, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:5, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:5, name: "Consectetur adipisicing elit", complexity:1, approach:0)
TechniqueTool.create(practice_id:5, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practice 6
TechniqueTool.create(practice_id:6, name: "Juicio experto", complexity:0, approach:1)
TechniqueTool.create(practice_id:6, name: "COCOMO", complexity:2, approach:1)
TechniqueTool.create(practice_id:6, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:6, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:1)

#Practica 7
TechniqueTool.create(practice_id:7, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:7, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:7, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:7, name: "Lorem ipsum dolor sit amet", complexity:2, approach:0)
TechniqueTool.create(practice_id:7, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practice 8
TechniqueTool.create(practice_id:8, name: "Juicio experto", complexity:0, approach:1)
TechniqueTool.create(practice_id:8, name: "COCOMO", complexity:2, approach:1)
TechniqueTool.create(practice_id:8, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:8, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:8, name: "Lorem ipsum dolor sit amet", complexity:2, approach:1)
TechniqueTool.create(practice_id:8, name: "Consectetur adipisicing elit", complexity:1, approach:1)
TechniqueTool.create(practice_id:8, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:1)


#Practica 9
TechniqueTool.create(practice_id:9, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:9, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:9, name: "Consectetur adipisicing elit", complexity:1, approach:0)
TechniqueTool.create(practice_id:9, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practica 10
TechniqueTool.create(practice_id:10, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:10, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:10, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:10, name: "Consectetur adipisicing elit", complexity:1, approach:0)
TechniqueTool.create(practice_id:10, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practica 11
TechniqueTool.create(practice_id:11, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:11, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:11, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:11, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:11, name: "Lorem ipsum dolor sit amet", complexity:2, approach:0)
TechniqueTool.create(practice_id:11, name: "Consectetur adipisicing elit", complexity:1, approach:0)
TechniqueTool.create(practice_id:11, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practice 12
TechniqueTool.create(practice_id:12, name: "Juicio experto", complexity:0, approach:1)
TechniqueTool.create(practice_id:12, name: "COCOMO", complexity:2, approach:1)
TechniqueTool.create(practice_id:12, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:12, name: "Lorem ipsum dolor sit amet", complexity:2, approach:1)
TechniqueTool.create(practice_id:12, name: "Consectetur adipisicing elit", complexity:1, approach:1)


#Practica 13
TechniqueTool.create(practice_id:13, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:13, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:13, name: "Método delphi", complexity:1, approach:1)
TechniqueTool.create(practice_id:13, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:13, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)

#Practica 14
TechniqueTool.create(practice_id:14, name: "Juicio experto", complexity:0, approach:2)
TechniqueTool.create(practice_id:14, name: "COCOMO", complexity:2, approach:2)
TechniqueTool.create(practice_id:14, name: "Planning poker", complexity:2, approach:1)
TechniqueTool.create(practice_id:14, name: "Lorem ipsum dolor sit amet", complexity:2, approach:0)
TechniqueTool.create(practice_id:14, name: "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", complexity:0, approach:2)
