import {store} from '../lib/store'
var upsert = require('../lib/upsert.js')
var moment = require('moment')

export tag SubmitRecords
  prop submits default: store:submits
  prop page default: 1
  prop isAdmin default: no
  prop useridfilter default: -1

  def setup
    crawl 1
    store:socket.on 'alert' do |data|
      if data:type == 'result'
        if @page == 1
          if data:subtask_id == undefined
            console.log('b4',@submits,data)
            @submits = upsert(@submits, data, "submission_id")
            console.log('ft',@submits)
        if data:subtask_id
          if @show == yes
            if @exePage == 1
              @executions = upsert(@executions,data,"job_id")
      Imba.commit

    window:$("#modal").modal()
    @executions = []
    @show = no
    @exePage = 1

  def crawl page
    var url = "/api/submits?page={page}"
    if @isAdmin
      if @useridfilter != -1
        url += '&userid=' + @useridfilter
      else
        url += '&all=true'
    window:$.ajax({url: url}).done do |data|
      @submits = data:submits
      console.log data
      Imba.commit
  
  def viewDetails sid
    console.log('view details',sid)
    window:$("#modal").modal('toggle')
    @show = yes

  def modalClose
    @show = no

  
  def render
    return 
      <self>
        <div.modal.fade id="modal">
          <div.modal-dialog role="document">
            <div.modal-content>
              <div.modal-header>
                <h5.modal-title id="modalTitle"> "Modal title"
                <button.close data-dismiss="modal">
              <div.modal-body>
                <table.table>
                  <thead>
                    <tr>
                      <th> "ID"
                      <th> "Start Time"
                      <th> "End Time"
                      <th> "Score"
                      <th> "Status"
                  <tbody>
                    for exe in @executions
                      <tr>
                        <th> exe:job_id
                        <th> exe:startTime
                        <th> exe:endTime
                        <th> exe:score || exe:error
                        <th> exe:status
              <div.modal-footer>
                <button.btn.btn-secondary data-dismiss="modal"> "Close"
        <p>
          "jump to page"
          <input[page] :change.crawl(@page)>
          if @isAdmin
            "filter userid(-1 for all)"
            <input[useridfilter] :change.crawl(@page)>
        <table.table.table-striped>
          <thead.thead-dark>
            <tr>
              <th> "ID"
              if @isAdmin
                <th> "UID"
              <th> "Start Time"
              <th> "End Time"
              <th> "Question"
              <th> "Score"
              <th> "Status"
              <th> "Details"
          <tbody>
            for submit in submits
              <tr>
                <td> submit:submission_id
                if @isAdmin
                  <td> submit:user_id
                <td> moment(submit:startTime).format 'YYYY-MM-DD HH:mm:ss'
                <td> moment(submit:endTime).format 'YYYY-MM-DD HH:mm:ss'
                <td> submit:question_id
                if submit:score == null
                  <td> submit:error
                else
                  <td> Math:round(100*submit:score)/100
                <td> submit:status
                <td>
                  <a.btn.btn-raised.btn-primary :tap.viewDetails(submit:submission_id) href="#col{submit:submission_id}"> "details"