function Div(el)
    if el.classes:includes('verse2') then
      if FORMAT:match('latex') then
        return {
          pandoc.RawBlock('latex', '\\begin{center}'),
          el,
          pandoc.RawBlock('latex', '\\end{center}')
        }
      end
    end
  end

  function Div(el)
    if el.classes:includes('verse') then
        if FORMAT:match('latex') then
            local content = pandoc.write(pandoc.Pandoc(el.content), "latex")
            return {
                pandoc.RawBlock('latex', '\\clearpage'),
                pandoc.RawBlock('latex', '\\vspace*{\\fill}'),
                pandoc.RawBlock('latex', '\\noindent\\begin{minipage}{\\textwidth}\\centering'),
                pandoc.RawBlock('latex', '\\Large'), -- << Añadido: tamaño de fuente
                pandoc.RawBlock('latex', '\\setlength{\\parskip}{1em}'), -- Espacio entre párrafos
                pandoc.RawBlock('latex', content),
                pandoc.RawBlock('latex', '\\end{minipage}'),
                pandoc.RawBlock('latex', '\\vspace*{\\fill}'),
                pandoc.RawBlock('latex', '\\clearpage')
            }
        end
    end
end


  
  function Header(el)
    if el.level == 1 and FORMAT:match('latex') then
      -- Salto de página + centrar encabezados h1
      return {
        pandoc.RawBlock('latex', '\\clearpage'),
        pandoc.RawBlock('latex', '\\begin{center}\\Huge\\textbf{' .. pandoc.utils.stringify(el.content) .. '}\\end{center}')
      }
    end
  end

-- Tabla de notas locales
local notes = {
    ["nota1"] = "Expresión que se suele traducir por «abandono de cuerpo y mente» a través de ella el maestro Dôgen Zenji realizó la Vía.",
    ["nota2"] = "Eihei Dōgen (永平道元) también Dōgen Zenji (道元禅師) o Dōgen Kigen (道元希玄) o Koso Joyo Daishi (literalmente Ancestro Eminente, Sustentador de Luz, Gran Maestro) (Kioto, 26 de enero de 1200 Ib., 29 de septiembre de 1253) fue el maestro zen fundador de la escuela Sōtō del Zen en Japón.",
    ["nota3"] = "Según la RAE.",
    ["nota4"] = "El Dàodé jīng (Chino: 道德經, Wade-Giles: Tao Te Ching, también llamado Tao Te King), también llamado Laozi (老子), es un texto clásico chino atribuido al sabio Lao-Tse del siglo VI a. C.",
    ["nota5"] = "Mahāyāna (sánscrito: «Gran Vehículo», o Bodhisattvayāna, «Vehículo del Bodhisattva») es, junto con el Theravada, una de las dos ramas principales del budismo.",
    ["nota6"] = "Maha Prajña Paramita Hridaya Sutra, en sánscrito. Maka Hannya Haramita Shingyo, en japonés",
    ["nota7"] = "Śūnyatā (AITS, /shuniáta/ o /shuniátaa/; Devanagari: शून्यता; Pali: suññatā), a menudo traducido como 'vacuidad', 'vaciedad' o 'vació' es un concepto budista que tiene múltiples significados dependiendo de su contexto doctrinal. Puede referirse a una comprensión ontológica de la realidad, un estado meditativo o un análisis fenomenológico de la experiencia.",
    ["nota9"] = "Un día en que Dogen estaba sentado en Zazen, su vecino se durmió. El maestro Nyojo golpeo con fuerza al discípulo y con voz fuerte gritó: “¡Zazen es abandonar cuerpo y mente!: ¿Por qué duermes?”. Al oír estas palabras, Dogen experimento el gran despertar. Después Dogen fue a ver a Nyojo y le dijo: “— He abandonado cuerpo y mente - shin jin datsu raku”. Nyojo le contestó: “-¡Abandona ahora la noción de haber abandonado cuerpo y mente!” Dogen se postró entonces respetuosamente ante Nyojo y este añadió: “Cuerpo y mente han sido abandonados - datsu raku shin jin” ",
    ["nota10"] = "Mushotoku es una expresión zen (無所得) que podría traducirse literalmente como ‘no provecho’, ‘no obtención’, o ‘nada que obtener’, lo que viene a significar ‘hacer algo sin esperar ningún beneficio personal’.",
    ["nota11"] = "Estado de profunda concentración meditativa en el cual la mente se vuelve completamente unificada y tranquila, dejando de estar dispersa o distraída. En este estado, el sentido de separación entre el sujeto y el objeto desaparece, y el practicante experimenta una absorción completa en la experiencia presente, trascendiendo la dualidad.",
    ["nota12"] = "En el budismo se corresponde con el sufrimiento, propio del mundo material, del que los seres humanos son los únicos seres renacidos dentro de los Seis reinos del samsara, que son capaces de distanciarse, mediante la liberación, y, posteriormente, de separarse, mediante el nirvana. El tiempo necesario para liberarse del samsara depende de las prácticas espirituales y del karma acumulado en vidas anteriores .",
    ["nota13"] = "En el budismo, se reconocen tanto la verdad relativa como la verdad absoluta. La verdad relativa reconoce la aparente dualidad entre el sujeto y el objeto en nuestra experiencia cotidiana, mientras que la verdad absoluta revela la vacuidad y la unidad fundamental de todos los fenómenos. Ambas perspectivas son complementarias y nos permiten comprender la realidad de manera más completa. Al reconocer la interconexión y la unidad subyacente del sujeto y el objeto, podemos trascender las limitaciones de la dualidad y experimentar la realidad en su plenitud.",
    ["nota15"] = "Dōgen. (s.f.). Genjōkōan [Texto completo]. Recuperado de https://zendogen.es/textos/shobogenzo/genjokoan/",
    ["nota14"] = "Blas Pascal (1623-1662) fue un filósofo y matemático francés conocido por sus contribuciones a la teoría de la probabilidad y la filosofía."
    
}

-- Función para procesar enlaces y convertirlos en notas al pie
function Link(el)
  if el.target:match("^#nota") then
      -- Extraer el identificador de la nota (por ejemplo, "nota1")
      local note_id = el.target:match("#(nota%d+)")
      -- Buscar el contenido de la nota en la tabla
      local note_content = notes[note_id] or "Nota no encontrada."
      -- Generar una nota al pie en LaTeX
      return pandoc.RawInline('latex', '\\footnote{' .. note_content .. '}')
  end
end
