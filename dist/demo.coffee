#Compile:
# cjsx -b -p -c demo.coffee > demo.js
# https://github.com/jsdf/coffee-react

WorkSpace = React.createClass
    getInitialState: () ->
        {
            state:'source',
            source:'',
            summary:'',
            button:'To summary'
        }

    onChangeSource: (e)->
        @setState
            source: e.target.value
        return

    renderSource:->
        <div>
            <textarea rows=3 onChange={@onChangeSource}>
                {@state.source}
            </textarea>
        </div>

    renderSummary:->
        <div>
            {@state.summary}
        </div>

    renderState:->
        if @state.state == "source"
            @renderSource()
        else
            @renderSummary()

    handleClick:->
        state = @state
        # console.log state.source
        if state.state == "source"
            state.state = "summary"
            state.button = "To source"
            summary = process_summary('',state.source)
            @state.summary = summary.summary
        else
            state.state = "source"
            state.source = @state.source
            state.button = "To summary"
        @setState(state)
        return

    render: ->
        <div>
            <h1>WorkSpace</h1>
            {@renderState()}
            <button onClick={@handleClick}>{@state.button}</button>
        </div>

demoApp = React.createClass
    render: ->
        <div>
            <h1>Summary.js demo app under react.js</h1>
            <WorkSpace/>
        </div>

prepare = ->
    wrapper = document.getElementById("wrapper")
    React.render(<demoApp/>,wrapper)

window.onload = prepare
