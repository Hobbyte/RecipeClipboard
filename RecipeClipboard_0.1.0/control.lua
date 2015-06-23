  require 'defines'
  ingredients = {}
  item = ""
  debug = false
  function dbg(s)
    if debug then game.player.print(game.tick .. ": " .. s) end
  end
  function getBtn(n)
    return game.player.gui.left[n]
  end
  function createButton(c, n)
    game.player.gui.left.add{type = 'button', caption = c, name = n}
  end
  function listSlots(es)
    for k,v in pairs(es) do
      if(type(v) == 'table') then
        listSlots(v)
      elseif type(v) == 'userdata' then
        dbg(k .. " : " .. serpent.block(v))
      else
        dbg(k .. " : " .. v)
      end
   end
  end

  game.onevent(defines.events.ontick,
  function(e)
    if game.player.opened then
      if pcall(function() return game.player.opened.recipe end) then
        if not getBtn('copyButton') then
          dbg('+ Copy button')
          createButton('Copy Build Requirements', 'copyButton')
        end
      elseif game.player.opened.name == 'logistic-chest-requester' then
        if not getBtn('pasteButton2') then
          dbg(' + Paste Button2')
           createButton('Paste 2', 'pasteButton2')
        end
		if not getBtn('pasteButton10') then
          dbg(' + Paste Button10')
           createButton('Paste 10', 'pasteButton10')
        end
      elseif game.player.opened.type == 'inserter' then
		if string.find(game.player.opened.name, "smart") then
			if not getBtn('pasteButton1') then
				createButton('Paste 1', 'pasteButton1')
			end
			if not getBtn('pasteButton5') then
				createButton('Paste 5', 'pasteButton5')
			end
			if not getBtn('pasteButton10') then
				createButton('Paste 10', 'pasteButton10')
			end
			if not getBtn('pasteButton50') then
				createButton('Paste 50', 'pasteButton50')
			end
        end
      end
    else
      if getBtn('copyButton') then
        dbg(' - Copy Button')
        getBtn('copyButton').destroy()
      end
      if getBtn('pasteButton1')  then
        dbg(' - Paste Button1')
          getBtn('pasteButton1').destroy()
      end
	  if getBtn('pasteButton2')  then
        dbg(' - Paste Button2')
          getBtn('pasteButton2').destroy()
      end
	  if getBtn('pasteButton5')  then
        dbg(' - Paste Button5')
          getBtn('pasteButton5').destroy()
      end
	  if getBtn('pasteButton10')  then
        dbg(' - Paste Button10')
          getBtn('pasteButton10').destroy()
      end
	  if getBtn('pasteButton50')  then
        dbg(' - Paste Button50')
          getBtn('pasteButton50').destroy()
      end
    end
  end)

function pasteNum(num)
	pcall(function()
        if game.player.opened.type == 'inserter' then
          pasteInserter(num)
        else
          local s = 0
		  local newIngredients = {}
		  
          for _,_ in pairs(ingredients) do s = s + 1 end
		  for k,v in pairs(ingredients) do
			newIngredients[k] = {name = v['name'], count = v['count'] * num}
		  end
		  dbg('ingredients:')
          listSlots(ingredients)
          for i=1,10 do
            local slot = game.player.opened.getrequestslot(i)
            if slot ~= nil then
              local n = slot['name']
              if ingredients[n] ~= nil then
				
                dbg('Updating item count [' .. n .. '] ' .. serpent.block(slot))
				newIngredients[n]['count'] = newIngredients[n]['count'] + slot['count']
              else
                newIngredients[n] = slot
              end
            end
          end
		  dbg('newIngredients:')
          listSlots(newIngredients)
          local i = 1
          for _,e in pairs(newIngredients) do
            game.player.opened.setrequestslot(e,i)
            i = i + 1
            if i > 10 then
              break
            end
          end
        end
      end)
end
function pasteInserter(num)
	if string.find(game.player.opened.name, "smart") then
		game.player.opened.setcircuitcondition {circuit = defines.circuitconnector.logistic, name = item, count = num, operator = "<"}
	end
end

  game.onevent(defines.events.onguiclick, function(event)
    if (event.element.name == 'copyButton') then
      pcall(function()
        local i = 0
        ingredients = {}
        item = game.player.opened.recipe.name
        for _,x in pairs(game.player.opened.recipe.ingredients) do
          listSlots(x)
          if x['type'] then
            if x['type'] == 0 then
              ingredients[x['name']] = {name = x['name'], count = x['amount']}
              dbg('Added [' .. serpent.block(x) .. ']')
            end
          end
        end
      end)
    end
	if (event.element.name == 'pasteButton1') then
		pasteNum(1)
	end
    if (event.element.name == 'pasteButton2') then
		pasteNum(2)
	end
	if (event.element.name == 'pasteButton5') then
		pasteNum(5)
	end
	if (event.element.name == 'pasteButton10') then
		pasteNum(10)
	end
	if (event.element.name == 'pasteButton50') then
		pasteNum(50)
	end
  end)
