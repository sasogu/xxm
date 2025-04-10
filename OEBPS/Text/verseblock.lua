function Div(el)
    if el.classes:includes('verse') then
      if FORMAT:match('latex') then
        return {
          pandoc.RawBlock('latex', '\\begin{center}'),
          el,
          pandoc.RawBlock('latex', '\\end{center}')
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
  
  