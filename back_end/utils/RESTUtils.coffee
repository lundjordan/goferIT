#
#  Very basic CRUD route creation utility for models.
#  For validation, simply override the model's save method.
#

errMsg = (msg) ->
    return error:
        message: msg.toString()

# ------------------------------
#  List
#
exports.getListController = (model) ->
    return (req, res) ->
        # console.log 'list', req.body
        model.find {}, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Create
#
exports.getCreateController = (model) ->
    return (req, res) ->
        #console.log('create', req.body);
        m = new model req.body
        m.save (err) ->
            if not err
                res.send m
            else
                res.send (errMsg err)

#------------------------------
# Read
#
exports.getReadController = (model) ->
    return (req, res) ->
        #console.log('read', req.body);
        model.findById req.params.id, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Update
#
exports.getUpdateController = (model) ->
    return (req, res) ->
        #console.log('update', req.body);
        model.findById req.params.id, (err, result) ->
            for key in req.body
                result[key] = req.body[key]

            result.save (err) ->
                if not err
                    res.send result
                else
                    res.send (errMsg err)

#------------------------------
# Delete
#
exports.getDeleteController = (model) ->
    return (req, res) ->
        #console.log('delete', req.body);
        model.findById req.params.id, (err, result) ->
            if err
                res.send (errMsg err)
            else
                result.remove()
                result.save (err) ->
                    if not err
                        res.send {}
                    else
                        res.send (errMsg err)
