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
    (req, res) ->
        model.find {_company: req.user._company}, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Create
#
exports.getCreateController = (model) ->
    return (req, res) ->
        console.log 'create', req.body
        m = new model req.body
        m._company = req.user._company
        m.save (err) ->
            if not err
                console.log m
                res.send m
            else
                console.log errMsg(err)
                res.send (errMsg err)

#------------------------------
# Read
#
exports.getReadController = (model) ->
    return (req, res) ->
        #console.log('read', req.body);
        model.findById req.params.id, (err, result) ->
            if not err
                return result
            else
                return (errMsg err)

#------------------------------
# Update
#
exports.getUpdateController = (model) ->
    return (req, res) ->
        console.log('update', req.body)
        model.findById req.params.id, (err, result) ->
            for key, value of req.body
                # console.log("req.body key: " + key)
                result[key] = value

            result.save (err) ->
                if not err
                    console.log result
                    return result
                else
                    console.log(errMsg err)
                    return (errMsg err)

#------------------------------
# Delete
#
exports.getDeleteController = (model) ->
    return (req, res) ->
        #console.log('delete', req.body);
        model.findById req.params.id, (err, result) ->
            if err
                return (errMsg err)
            else
                result.remove()
                result.save (err) ->
                    if not err
                        console.log result
                        return {}
                    else
                        console.log(errMsg err)
                        return (errMsg err)
