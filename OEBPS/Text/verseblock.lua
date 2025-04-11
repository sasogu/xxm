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

