window.init_blog = () ->
	
	bo =
		w: window.innerWidth
		h: window.innerHeight
		curr:0
		curr_note:0
		curr_cb: () ->

	bo['thresh'] = bo.w*0.15

	bo['imgs'] =
		0:init_img('01.11.2014',{
			'the last place on earth':[0.35,0.65,1,img01]
			'our vanishing point':[0.5,0.02,2,img01]
			'229102 interwoven souls, of who we are two':[0.5,0.2,3,img01]
			'the background is mostly static, if you squint you can make out dim shapes, moulting':[0.25,0.25,4,img01]
		})
		1:init_img('02.34.2014', {
			'the last place on earth':[0.1,0.1]
			'the lonely turtle':[0.2,0.2]
		})
		2:init_img('03.01.2014', {
			'the last place on earth':[0.1,0.1]
			'the lonely turtle':[0.2,0.2]
		})
	
	init_body bo
	init_menu bo
	init_imgs bo

	change_img(bo,0)

	animate bo

animate = (bo) ->
	bo.curr_cb bo
	requestAnimationFrame () -> animate(bo)

init_img = (date,notes) ->
	'date':date
	'notes':notes

init_body = (bo) ->
	$(document).css
		cursor:'pointer'

init_menu = (bo) ->

	menu = $('<div>')
	
	menu.css
		width:'150px'
		textAlign:'left'
		paddingLeft: '20px'
		paddingRight: '20px'
		paddingTop: '100px'
		fontSize: '18px'

	menu.attr
		id:'menu'

	menu.html(' ---> the things')
	menu.appendTo('body')
	
	for i in Object.keys bo.imgs
		do (i)->
			entry = $('<div>')
			entry.html bo.imgs[i].date
			entry.appendTo(menu)
			entry.css
				cursor: 'pointer'
				fontSize: '15px'
				paddingLeft: '20px'
			entry.hover(() ->
					entry.css
						textDecoration:'underline'
				,() ->
					entry.css
						textDecoration:'none'
			)
			entry.click () ->
				change_img(bo,i)

init_imgs = (bo) ->
	left_offset = $('#menu').width() + 30 # hardcoded,  maybe fix
	img_holder = $ '<div>'
	img_holder.appendTo 'body'
	img_holder.attr
		id:'img-holder'

	img_holder.css
		position:'fixed'
		backgroundSize:'cover'
		backgroundPosition:'center'
		fontSize:20
		overflow:'hidden'
		marginLeft: left_offset
		top: 0
		height:bo.h
		width: bo.w- left_offset
		background:'transparent'

	img_bg = $ '<div>'
	img_bg.appendTo img_holder
	img_bg.attr
		id:'img-bg'
	img_bg.css
		position:'fixed'
		height:bo.h
		width: bo.w-left_offset
	

	img = $ '<img>'
	img.css
		position:'absolute'
		width:'100%'
		height:'100%'
	img.appendTo img_holder
	img.attr
		id:'img'

	img.mousemove (e) -> show_notes(bo,e)

	notes_holder = $ '<div>'
	notes_holder.attr
		id:'notes-holder'
	notes_holder.css
		position:'fixed'
		marginLeft: left_offset
		top: 0
	notes_holder.appendTo img_holder

show_notes = (bo,e) ->
	notes_holder = $('#notes-holder')
	notes_holder.empty()
	# show closes note
	closest =
		d:bo.w*bo.h
	for id in Object.keys bo.imgs[bo.curr].notes
		note = bo.imgs[bo.curr].notes[id]
		d = dist(e.clientX,e.clientY,bo.w*note[0],bo.h*note[1])
		if d < bo.thresh and d < closest.d
			closest =
				d:d
				id:id
				note:note

	if closest.d < bo.w*bo.h
		show_note(bo,closest.note,closest.id,closest.d,e)

show_note = (bo,note,id,d,e) ->
	bo.curr_note = note[2]
	notes_holder = $('#notes-holder')
	note_frame = $ '<div>'
	note_frame.appendTo(notes_holder)
	note_frame.html id
	note_frame.css
		position:'fixed'
		left:e.clientX+20
		top:e.clientY+20
		width:300
		pointerEvents:'none'
	img = $ '#img'
	img.attr
		src:'assets/img_'+bo.curr+''+note[2]+'.png'
	
	bo.curr_cb = note[3]
	
dist = (x1,y1,x2,y2) ->
	Math.pow(Math.pow(x1-x2,2)+Math.pow(y1-y2,2),0.5)

change_img = (bo,i) ->
	notes_holder = $('#notes-holder')
	notes_holder.empty()
	img = $ '#img'
	img.attr
		src:'assets/img_'+i+'0.png'

	'''
	for id in Object.keys bo.imgs[i].notes
		note = bo.imgs[i].notes[id]
		note_frame = $ '<div>'
		note_frame.appendTo(notes_holder)
		note_frame.html id
		note_frame.css
			position:'absolute'
			left:bo.w*note[0]
			top:bo.h*note[1]
			width:300
			'''

# CALLBACKS
img01 = (bo)->
	#if bo.curr_note == 1 and bo.curr == 0
	img_bg = $ '#img-bg'
	if img_bg.html().length < 4000
		img_bg.html ' is here ' + img_bg.html()



