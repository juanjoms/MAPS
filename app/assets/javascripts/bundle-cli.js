(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
module.exports = require('./lib');
},{"./lib":15}],2:[function(require,module,exports){
'use strict';

var isArray = require('lodash/lang/isArray'),
    isNumber = require('lodash/lang/isNumber'),
    isString = require('lodash/lang/isString'),
    isFunction = require('lodash/lang/isFunction'),
    forEach = require('lodash/collection/forEach');

function asArray(args) {
  return Array.prototype.slice.call(args);
}

function asParam(parse) {
  return function(name, options) {
    return {
      name: name,
      parse: function(val) {
        return parse(val, options || {});
      }
    };
  };
}

function StringParser() {
  return function(arg, options) {
    // support variable arguments
    if (isArray(arg)) {
      arg = arg.join(' ');
    }

    if (arg !== '' && !arg) {
      if (options.defaultValue) {
        return options.defaultValue;
      } else {
        throw new Error('no value given');
      }
    } else {
      return arg;
    }
  };
}

function BooleanParser() {
  return function(arg, options) {
    if (!arg) {
      if (options.defaultValue) {
        return options.defaultValue;
      }

      if (options.optional) {
        return undefined;
      }

      throw new Error('no value given');
    } else {
      return arg && arg !== 'false';
    }
  };
}

function NumberParser() {
  return function(arg, options) {
    if (arg !== 0 && !arg) {
      if (options.defaultValue) {
        return options.defaultValue;
      } else {
        throw new Error('no value given');
      }
    } else {
      return isNumber(arg) ? arg : parseFloat(arg, 10);
    }
  };
}

function Cli(config, injector) {

  this._commands = {};
  this._params = {};

  this._injector = injector;

  this._registerParsers();
  this._registerCommands();

  this._bind(config);
}

Cli.$inject = [ 'config', 'injector' ];

module.exports = Cli;


// reset prototype (ain't gonna inherit from object)

Cli.prototype = {};


/////// helpers //////////////////////////

Cli.prototype._bind = function(config) {
  if (config.cli && config.cli.bindTo) {
    console.info('bpmn-js-cli is available via window.' + config.cli.bindTo);
    window[config.cli.bindTo] = this;
  }
};

Cli.prototype._registerParser = function(name, Parser) {
  var parser = this._injector.invoke(Parser);

  // must return a function(val, options) -> result
  if (!isFunction(parser)) {
    throw new Error('parser must be a Function<String, Object> -> Object');
  }

  this._params[name] = asParam(parser);
};

Cli.prototype._registerCommand = function(name, Command) {

  var command = isFunction(Command) ? this._injector.invoke(Command) : Command;

  command.args = command.args || [];

  this._commands[name] = command;

  var self = this;

  this[name] = function() {
    var args = asArray(arguments);
    args.unshift(name);

    return self.exec.apply(self, args);
  };
};

Cli.prototype._registerParsers = function() {
  this._registerParser('string', StringParser);
  this._registerParser('number', NumberParser);
  this._registerParser('bool', BooleanParser);
};

Cli.prototype._registerCommands = function() {

  var self = this;

  // special <help> command
  this._registerCommand('help', {
    exec: function() {
      var help = 'available commands:\n';

      forEach(self._commands, function(c, name) {
        help += '\n\t' + name;
      });

      return help;
    }
  });
};

Cli.prototype.parseArguments = function(args, command) {

  var results = [];

  var last = command.args.length -1;

  forEach(command.args, function(c, i) {

    var val;

    // last arg receives array of all remaining parameters
    if (i === last && args.length > command.args.length) {
      val = args.slice(i);
    } else {
      val = args[i];
    }

    try {
      results.push(c.parse(val));
    } catch (e) {
      throw new Error('could not parse <' + c.name + '>: ' + e.message);
    }
  });

  return results;
};

Cli.prototype.exec = function() {

  var args = [];

  // convert mixed whitespace separated string / object assignments in args list
  // to correct argument representation
  asArray(arguments).forEach(function(arg) {
    if (isString(arg)) {
      args = args.concat(arg.split(/\s+/));
    } else {
      args.push(arg);
    }
  });

  var name = args.shift();

  var command = this._commands[name];
  if (!command) {
    throw new Error('no command <' + name + '>, execute <commands> to get a list of available commands');
  }

  var values, result;

  try {
    values = this.parseArguments(args, command);
    result = command.exec.apply(this, values);
  } catch (e) {
    throw new Error('failed to execute <' + name + '> with args <[' + args.join(', ') + ']> : ' + e.message);
  }

  return result;
};
},{"lodash/collection/forEach":21,"lodash/lang/isArray":40,"lodash/lang/isFunction":41,"lodash/lang/isNumber":43,"lodash/lang/isString":45}],3:[function(require,module,exports){
'use strict';


function AppendCommand(params, modeling) {

  return {
    args: [
      params.shape('source'),
      params.string('type'),
      params.point('delta', { defaultValue: { x: 200, y: 0 } } )
    ],
    exec: function(source, type, delta) {
      var newPosition = {
        x: source.x + source.width / 2 + delta.x,
        y: source.y + source.height / 2 + delta.y
      };

      return modeling.appendShape(source, { type: type }, newPosition).id;
    }
  };
}

AppendCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = AppendCommand;
},{}],4:[function(require,module,exports){
'use strict';


function ConnectCommand(params, modeling) {

  return {
    args: [
      params.shape('source'),
      params.shape('target'),
      params.string('type'),
      params.shape('parent', { optional: true }),
    ],
    exec: function(source, target, type, parent) {
      return modeling.createConnection(source, target, {
        type: type,
      }, parent || source.parent).id;
    }
  };
}

ConnectCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = ConnectCommand;
},{}],5:[function(require,module,exports){
'use strict';


function CreateCommand(params, modeling) {

  return {
    args: [
      params.string('type'),
      params.point('position'),
      params.shape('parent'),
      params.bool('isAttach', { optional: true })
    ],
    exec: function(type, position, parent, isAttach) {
      return modeling.createShape({ type: type }, position, parent, isAttach).id;
    }
  };
}

CreateCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = CreateCommand;
},{}],6:[function(require,module,exports){
'use strict';

function ElementCommand(params) {

  return {
    args: [ params.element('element') ],
    exec: function(element) {
      return element;
    }
  };
}

ElementCommand.$inject = [ 'cli._params' ];

module.exports = ElementCommand;
},{}],7:[function(require,module,exports){
'use strict';

function ElementsCommand(params, elementRegistry) {

  return {
    exec: function() {
      function all() {
        return true;
      }

      function ids(e) {
        return e.id;
      }

      return elementRegistry.filter(all).map(ids);
    }
  };
}

ElementsCommand.$inject = [ 'cli._params', 'elementRegistry' ];

module.exports = ElementsCommand;
},{}],8:[function(require,module,exports){
'use strict';


function MoveCommand(params, modeling) {

  return {
    args: [
      params.shapes('shapes'),
      params.point('delta'),
      params.shape('newParent', { optional: true }),
      params.bool('isAttach', { optional: true })
    ],
    exec: function(shapes, delta, newParent, isAttach) {
      modeling.moveElements(shapes, delta, newParent, isAttach);
      return shapes;
    }
  };
}

MoveCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = MoveCommand;
},{}],9:[function(require,module,exports){
'use strict';


function RedoCommand(commandStack) {

  return {
    exec: function() {
      commandStack.redo();
    }
  };
}

RedoCommand.$inject = [ 'commandStack' ];

module.exports = RedoCommand;
},{}],10:[function(require,module,exports){
'use strict';


function RemoveConnectionCommand(params, modeling) {

  return {
    args: [
      params.element('connection')
    ],
    exec: function(connection) {
      return modeling.removeConnection(connection);
    }
  };
}

RemoveConnectionCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = RemoveConnectionCommand;

},{}],11:[function(require,module,exports){
'use strict';


function RemoveShapeCommand(params, modeling) {

  return {
    args: [
      params.shape('shape')
    ],
    exec: function(shape) {
      return modeling.removeShape(shape);
    }
  };
}

RemoveShapeCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = RemoveShapeCommand;

},{}],12:[function(require,module,exports){
'use strict';


function SaveCommand(params, bpmnjs) {

  return {
    args: [ params.string('format') ],
    exec: function(format) {

      if (format === 'svg') {
        bpmnjs.saveSVG(function(err, svg) {

          if (err) {
            console.error(err);
          } else {
            console.info(svg);
          }
        });
      } else if (format === 'bpmn') {
        return bpmnjs.saveXML(function(err, xml) {

          if (err) {
            console.error(err);
          } else {
            console.info(xml);
          }
        });
      } else {
        throw new Error('unknown format, <svg> and <bpmn> are available');
      }
    }
  };
}

SaveCommand.$inject = [ 'cli._params', 'bpmnjs' ];

module.exports = SaveCommand;
},{}],13:[function(require,module,exports){
'use strict';


function SetLabelCommand(params, modeling) {

  return {
    args: [ params.element('element'), params.string('newLabel') ],
    exec: function(element, newLabel) {
      modeling.updateLabel(element, newLabel);
      return element;
    }
  };
}

SetLabelCommand.$inject = [ 'cli._params', 'modeling' ];

module.exports = SetLabelCommand;
},{}],14:[function(require,module,exports){
'use strict';


function UndoCommand(commandStack) {

  return {
    exec: function() {
      commandStack.undo();
    }
  };
}

UndoCommand.$inject = [ 'commandStack' ];

module.exports = UndoCommand;
},{}],15:[function(require,module,exports){
module.exports = {
  __init__: [ 'cliInitializer' ],
  cli: [ 'type', require('./cli') ],
  cliInitializer: [ 'type', require('./initializer') ]
};
},{"./cli":2,"./initializer":16}],16:[function(require,module,exports){
'use strict';

function Initializer(cli) {

  // parsers
  cli._registerParser('point',    require('./parsers/point'));
  cli._registerParser('element',  require('./parsers/element'));
  cli._registerParser('shape',    require('./parsers/shape'));
  cli._registerParser('shapes',   require('./parsers/shapes'));

  // commands
  cli._registerCommand('append',            require('./commands/append'));
  cli._registerCommand('connect',           require('./commands/connect'));
  cli._registerCommand('create',            require('./commands/create'));
  cli._registerCommand('element',           require('./commands/element'));
  cli._registerCommand('elements',          require('./commands/elements'));
  cli._registerCommand('move',              require('./commands/move'));
  cli._registerCommand('redo',              require('./commands/redo'));
  cli._registerCommand('save',              require('./commands/save'));
  cli._registerCommand('setLabel',          require('./commands/set-label'));
  cli._registerCommand('undo',              require('./commands/undo'));
  cli._registerCommand('removeShape',       require('./commands/removeShape'));
  cli._registerCommand('removeConnection',  require('./commands/removeConnection'));
}

Initializer.$inject = [ 'cli' ];

module.exports = Initializer;

},{"./commands/append":3,"./commands/connect":4,"./commands/create":5,"./commands/element":6,"./commands/elements":7,"./commands/move":8,"./commands/redo":9,"./commands/removeConnection":10,"./commands/removeShape":11,"./commands/save":12,"./commands/set-label":13,"./commands/undo":14,"./parsers/element":17,"./parsers/point":18,"./parsers/shape":19,"./parsers/shapes":20}],17:[function(require,module,exports){
'use strict';

var isObject = require('lodash/lang/isObject');


function ElementParser(elementRegistry) {

  return function(arg, options) {
    // assume element passed is shape already
    if (isObject(arg)) {
      return arg;
    }

    var e = elementRegistry.get(arg);
    if (!e) {
      if (options.optional) {
        return null;
      } else {
        if (arg) {
          throw new Error('element with id <' + arg + '> does not exist');
        } else {
          throw new Error('argument required');
        }
      }
    }

    return e;
  };
}

ElementParser.$inject = [ 'elementRegistry' ];

module.exports = ElementParser;
},{"lodash/lang/isObject":44}],18:[function(require,module,exports){
'use strict';

var isObject = require('lodash/lang/isObject');


/**
 * Parses 12,12 to { x: 12, y: 12 }.
 * Allows nulls, i.e ,12 -> { x: 0, y: 12 }
 */
function PointParser() {

  return function(arg, options) {
    // assume element passed is delta already
    if (isObject(arg)) {
      return arg;
    }

    if (!arg && options.defaultValue) {
      return options.defaultValue;
    }

    var parts = arg.split(/,/);

    if (parts.length !== 2) {
      throw new Error('expected delta to match (\\d*,\\d*)');
    }

    return {
      x: parseInt(parts[0], 10) || 0,
      y: parseInt(parts[1], 10) || 0
    };
  };
}

module.exports = PointParser;
},{"lodash/lang/isObject":44}],19:[function(require,module,exports){
'use strict';

var isObject = require('lodash/lang/isObject');


/**
 * Parses a single shape from an object or string
 */
function ShapeParser(elementRegistry) {

  return function(arg, options) {

    // assume element passed is shape already
    if (isObject(arg)) {
      return arg;
    }

    var e = elementRegistry.get(arg);
    if (!e) {
      if (options.optional) {
        return null;
      } else {
        if (arg) {
          throw new Error('element with id <' + arg + '> does not exist');
        } else {
          throw new Error('argument required');
        }
      }
    }

    if (e.waypoints) {
      throw new Error('element <' + arg + '> is a connection');
    }

    return e;
  };
}

ShapeParser.$inject = [ 'elementRegistry' ];

module.exports = ShapeParser;
},{"lodash/lang/isObject":44}],20:[function(require,module,exports){
'use strict';

var isArray = require('lodash/lang/isArray'),
    isObject = require('lodash/lang/isObject'),
    isString = require('lodash/lang/isString');


/**
 * Parses a list of spahes shape from a list of objects or a comma-separated string
 */
function ShapesParser(elementRegistry) {

  return function(args, options) {

    if (isString(args)) {
      args = args.split(',');
    } else
    if (!isArray(args)) {
      args = [ args ];
    }

    return args.map(function(arg) {

      // assume element passed is shape already
      if (isObject(arg)) {
        return arg;
      }

      var e = elementRegistry.get(arg);
      if (!e) {
        if (options.optional) {
          return null;
        } else {
          if (arg) {
            throw new Error('element with id <' + arg + '> does not exist');
          } else {
            throw new Error('argument required');
          }
        }
      }

      if (e.waypoints) {
        throw new Error('element <' + arg + '> is a connection');
      }

      return e;
    }).filter(function(e) { return e; });
  };
}

ShapesParser.$inject = [ 'elementRegistry' ];

module.exports = ShapesParser;
},{"lodash/lang/isArray":40,"lodash/lang/isObject":44,"lodash/lang/isString":45}],21:[function(require,module,exports){
var arrayEach = require('../internal/arrayEach'),
    baseEach = require('../internal/baseEach'),
    createForEach = require('../internal/createForEach');

/**
 * Iterates over elements of `collection` invoking `iteratee` for each element.
 * The `iteratee` is bound to `thisArg` and invoked with three arguments:
 * (value, index|key, collection). Iteratee functions may exit iteration early
 * by explicitly returning `false`.
 *
 * **Note:** As with other "Collections" methods, objects with a "length" property
 * are iterated like arrays. To avoid this behavior `_.forIn` or `_.forOwn`
 * may be used for object iteration.
 *
 * @static
 * @memberOf _
 * @alias each
 * @category Collection
 * @param {Array|Object|string} collection The collection to iterate over.
 * @param {Function} [iteratee=_.identity] The function invoked per iteration.
 * @param {*} [thisArg] The `this` binding of `iteratee`.
 * @returns {Array|Object|string} Returns `collection`.
 * @example
 *
 * _([1, 2]).forEach(function(n) {
 *   console.log(n);
 * }).value();
 * // => logs each value from left to right and returns the array
 *
 * _.forEach({ 'a': 1, 'b': 2 }, function(n, key) {
 *   console.log(n, key);
 * });
 * // => logs each value-key pair and returns the object (iteration order is not guaranteed)
 */
var forEach = createForEach(arrayEach, baseEach);

module.exports = forEach;

},{"../internal/arrayEach":22,"../internal/baseEach":23,"../internal/createForEach":30}],22:[function(require,module,exports){
/**
 * A specialized version of `_.forEach` for arrays without support for callback
 * shorthands and `this` binding.
 *
 * @private
 * @param {Array} array The array to iterate over.
 * @param {Function} iteratee The function invoked per iteration.
 * @returns {Array} Returns `array`.
 */
function arrayEach(array, iteratee) {
  var index = -1,
      length = array.length;

  while (++index < length) {
    if (iteratee(array[index], index, array) === false) {
      break;
    }
  }
  return array;
}

module.exports = arrayEach;

},{}],23:[function(require,module,exports){
var baseForOwn = require('./baseForOwn'),
    createBaseEach = require('./createBaseEach');

/**
 * The base implementation of `_.forEach` without support for callback
 * shorthands and `this` binding.
 *
 * @private
 * @param {Array|Object|string} collection The collection to iterate over.
 * @param {Function} iteratee The function invoked per iteration.
 * @returns {Array|Object|string} Returns `collection`.
 */
var baseEach = createBaseEach(baseForOwn);

module.exports = baseEach;

},{"./baseForOwn":25,"./createBaseEach":28}],24:[function(require,module,exports){
var createBaseFor = require('./createBaseFor');

/**
 * The base implementation of `baseForIn` and `baseForOwn` which iterates
 * over `object` properties returned by `keysFunc` invoking `iteratee` for
 * each property. Iteratee functions may exit iteration early by explicitly
 * returning `false`.
 *
 * @private
 * @param {Object} object The object to iterate over.
 * @param {Function} iteratee The function invoked per iteration.
 * @param {Function} keysFunc The function to get the keys of `object`.
 * @returns {Object} Returns `object`.
 */
var baseFor = createBaseFor();

module.exports = baseFor;

},{"./createBaseFor":29}],25:[function(require,module,exports){
var baseFor = require('./baseFor'),
    keys = require('../object/keys');

/**
 * The base implementation of `_.forOwn` without support for callback
 * shorthands and `this` binding.
 *
 * @private
 * @param {Object} object The object to iterate over.
 * @param {Function} iteratee The function invoked per iteration.
 * @returns {Object} Returns `object`.
 */
function baseForOwn(object, iteratee) {
  return baseFor(object, iteratee, keys);
}

module.exports = baseForOwn;

},{"../object/keys":46,"./baseFor":24}],26:[function(require,module,exports){
/**
 * The base implementation of `_.property` without support for deep paths.
 *
 * @private
 * @param {string} key The key of the property to get.
 * @returns {Function} Returns the new function.
 */
function baseProperty(key) {
  return function(object) {
    return object == null ? undefined : object[key];
  };
}

module.exports = baseProperty;

},{}],27:[function(require,module,exports){
var identity = require('../utility/identity');

/**
 * A specialized version of `baseCallback` which only supports `this` binding
 * and specifying the number of arguments to provide to `func`.
 *
 * @private
 * @param {Function} func The function to bind.
 * @param {*} thisArg The `this` binding of `func`.
 * @param {number} [argCount] The number of arguments to provide to `func`.
 * @returns {Function} Returns the callback.
 */
function bindCallback(func, thisArg, argCount) {
  if (typeof func != 'function') {
    return identity;
  }
  if (thisArg === undefined) {
    return func;
  }
  switch (argCount) {
    case 1: return function(value) {
      return func.call(thisArg, value);
    };
    case 3: return function(value, index, collection) {
      return func.call(thisArg, value, index, collection);
    };
    case 4: return function(accumulator, value, index, collection) {
      return func.call(thisArg, accumulator, value, index, collection);
    };
    case 5: return function(value, other, key, object, source) {
      return func.call(thisArg, value, other, key, object, source);
    };
  }
  return function() {
    return func.apply(thisArg, arguments);
  };
}

module.exports = bindCallback;

},{"../utility/identity":48}],28:[function(require,module,exports){
var getLength = require('./getLength'),
    isLength = require('./isLength'),
    toObject = require('./toObject');

/**
 * Creates a `baseEach` or `baseEachRight` function.
 *
 * @private
 * @param {Function} eachFunc The function to iterate over a collection.
 * @param {boolean} [fromRight] Specify iterating from right to left.
 * @returns {Function} Returns the new base function.
 */
function createBaseEach(eachFunc, fromRight) {
  return function(collection, iteratee) {
    var length = collection ? getLength(collection) : 0;
    if (!isLength(length)) {
      return eachFunc(collection, iteratee);
    }
    var index = fromRight ? length : -1,
        iterable = toObject(collection);

    while ((fromRight ? index-- : ++index < length)) {
      if (iteratee(iterable[index], index, iterable) === false) {
        break;
      }
    }
    return collection;
  };
}

module.exports = createBaseEach;

},{"./getLength":31,"./isLength":35,"./toObject":38}],29:[function(require,module,exports){
var toObject = require('./toObject');

/**
 * Creates a base function for `_.forIn` or `_.forInRight`.
 *
 * @private
 * @param {boolean} [fromRight] Specify iterating from right to left.
 * @returns {Function} Returns the new base function.
 */
function createBaseFor(fromRight) {
  return function(object, iteratee, keysFunc) {
    var iterable = toObject(object),
        props = keysFunc(object),
        length = props.length,
        index = fromRight ? length : -1;

    while ((fromRight ? index-- : ++index < length)) {
      var key = props[index];
      if (iteratee(iterable[key], key, iterable) === false) {
        break;
      }
    }
    return object;
  };
}

module.exports = createBaseFor;

},{"./toObject":38}],30:[function(require,module,exports){
var bindCallback = require('./bindCallback'),
    isArray = require('../lang/isArray');

/**
 * Creates a function for `_.forEach` or `_.forEachRight`.
 *
 * @private
 * @param {Function} arrayFunc The function to iterate over an array.
 * @param {Function} eachFunc The function to iterate over a collection.
 * @returns {Function} Returns the new each function.
 */
function createForEach(arrayFunc, eachFunc) {
  return function(collection, iteratee, thisArg) {
    return (typeof iteratee == 'function' && thisArg === undefined && isArray(collection))
      ? arrayFunc(collection, iteratee)
      : eachFunc(collection, bindCallback(iteratee, thisArg, 3));
  };
}

module.exports = createForEach;

},{"../lang/isArray":40,"./bindCallback":27}],31:[function(require,module,exports){
var baseProperty = require('./baseProperty');

/**
 * Gets the "length" property value of `object`.
 *
 * **Note:** This function is used to avoid a [JIT bug](https://bugs.webkit.org/show_bug.cgi?id=142792)
 * that affects Safari on at least iOS 8.1-8.3 ARM64.
 *
 * @private
 * @param {Object} object The object to query.
 * @returns {*} Returns the "length" value.
 */
var getLength = baseProperty('length');

module.exports = getLength;

},{"./baseProperty":26}],32:[function(require,module,exports){
var isNative = require('../lang/isNative');

/**
 * Gets the native function at `key` of `object`.
 *
 * @private
 * @param {Object} object The object to query.
 * @param {string} key The key of the method to get.
 * @returns {*} Returns the function if it's native, else `undefined`.
 */
function getNative(object, key) {
  var value = object == null ? undefined : object[key];
  return isNative(value) ? value : undefined;
}

module.exports = getNative;

},{"../lang/isNative":42}],33:[function(require,module,exports){
var getLength = require('./getLength'),
    isLength = require('./isLength');

/**
 * Checks if `value` is array-like.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is array-like, else `false`.
 */
function isArrayLike(value) {
  return value != null && isLength(getLength(value));
}

module.exports = isArrayLike;

},{"./getLength":31,"./isLength":35}],34:[function(require,module,exports){
/** Used to detect unsigned integer values. */
var reIsUint = /^\d+$/;

/**
 * Used as the [maximum length](http://ecma-international.org/ecma-262/6.0/#sec-number.max_safe_integer)
 * of an array-like value.
 */
var MAX_SAFE_INTEGER = 9007199254740991;

/**
 * Checks if `value` is a valid array-like index.
 *
 * @private
 * @param {*} value The value to check.
 * @param {number} [length=MAX_SAFE_INTEGER] The upper bounds of a valid index.
 * @returns {boolean} Returns `true` if `value` is a valid index, else `false`.
 */
function isIndex(value, length) {
  value = (typeof value == 'number' || reIsUint.test(value)) ? +value : -1;
  length = length == null ? MAX_SAFE_INTEGER : length;
  return value > -1 && value % 1 == 0 && value < length;
}

module.exports = isIndex;

},{}],35:[function(require,module,exports){
/**
 * Used as the [maximum length](http://ecma-international.org/ecma-262/6.0/#sec-number.max_safe_integer)
 * of an array-like value.
 */
var MAX_SAFE_INTEGER = 9007199254740991;

/**
 * Checks if `value` is a valid array-like length.
 *
 * **Note:** This function is based on [`ToLength`](http://ecma-international.org/ecma-262/6.0/#sec-tolength).
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a valid length, else `false`.
 */
function isLength(value) {
  return typeof value == 'number' && value > -1 && value % 1 == 0 && value <= MAX_SAFE_INTEGER;
}

module.exports = isLength;

},{}],36:[function(require,module,exports){
/**
 * Checks if `value` is object-like.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is object-like, else `false`.
 */
function isObjectLike(value) {
  return !!value && typeof value == 'object';
}

module.exports = isObjectLike;

},{}],37:[function(require,module,exports){
var isArguments = require('../lang/isArguments'),
    isArray = require('../lang/isArray'),
    isIndex = require('./isIndex'),
    isLength = require('./isLength'),
    keysIn = require('../object/keysIn');

/** Used for native method references. */
var objectProto = Object.prototype;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/**
 * A fallback implementation of `Object.keys` which creates an array of the
 * own enumerable property names of `object`.
 *
 * @private
 * @param {Object} object The object to query.
 * @returns {Array} Returns the array of property names.
 */
function shimKeys(object) {
  var props = keysIn(object),
      propsLength = props.length,
      length = propsLength && object.length;

  var allowIndexes = !!length && isLength(length) &&
    (isArray(object) || isArguments(object));

  var index = -1,
      result = [];

  while (++index < propsLength) {
    var key = props[index];
    if ((allowIndexes && isIndex(key, length)) || hasOwnProperty.call(object, key)) {
      result.push(key);
    }
  }
  return result;
}

module.exports = shimKeys;

},{"../lang/isArguments":39,"../lang/isArray":40,"../object/keysIn":47,"./isIndex":34,"./isLength":35}],38:[function(require,module,exports){
var isObject = require('../lang/isObject');

/**
 * Converts `value` to an object if it's not one.
 *
 * @private
 * @param {*} value The value to process.
 * @returns {Object} Returns the object.
 */
function toObject(value) {
  return isObject(value) ? value : Object(value);
}

module.exports = toObject;

},{"../lang/isObject":44}],39:[function(require,module,exports){
var isArrayLike = require('../internal/isArrayLike'),
    isObjectLike = require('../internal/isObjectLike');

/** Used for native method references. */
var objectProto = Object.prototype;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/** Native method references. */
var propertyIsEnumerable = objectProto.propertyIsEnumerable;

/**
 * Checks if `value` is classified as an `arguments` object.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is correctly classified, else `false`.
 * @example
 *
 * _.isArguments(function() { return arguments; }());
 * // => true
 *
 * _.isArguments([1, 2, 3]);
 * // => false
 */
function isArguments(value) {
  return isObjectLike(value) && isArrayLike(value) &&
    hasOwnProperty.call(value, 'callee') && !propertyIsEnumerable.call(value, 'callee');
}

module.exports = isArguments;

},{"../internal/isArrayLike":33,"../internal/isObjectLike":36}],40:[function(require,module,exports){
var getNative = require('../internal/getNative'),
    isLength = require('../internal/isLength'),
    isObjectLike = require('../internal/isObjectLike');

/** `Object#toString` result references. */
var arrayTag = '[object Array]';

/** Used for native method references. */
var objectProto = Object.prototype;

/**
 * Used to resolve the [`toStringTag`](http://ecma-international.org/ecma-262/6.0/#sec-object.prototype.tostring)
 * of values.
 */
var objToString = objectProto.toString;

/* Native method references for those with the same name as other `lodash` methods. */
var nativeIsArray = getNative(Array, 'isArray');

/**
 * Checks if `value` is classified as an `Array` object.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is correctly classified, else `false`.
 * @example
 *
 * _.isArray([1, 2, 3]);
 * // => true
 *
 * _.isArray(function() { return arguments; }());
 * // => false
 */
var isArray = nativeIsArray || function(value) {
  return isObjectLike(value) && isLength(value.length) && objToString.call(value) == arrayTag;
};

module.exports = isArray;

},{"../internal/getNative":32,"../internal/isLength":35,"../internal/isObjectLike":36}],41:[function(require,module,exports){
var isObject = require('./isObject');

/** `Object#toString` result references. */
var funcTag = '[object Function]';

/** Used for native method references. */
var objectProto = Object.prototype;

/**
 * Used to resolve the [`toStringTag`](http://ecma-international.org/ecma-262/6.0/#sec-object.prototype.tostring)
 * of values.
 */
var objToString = objectProto.toString;

/**
 * Checks if `value` is classified as a `Function` object.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is correctly classified, else `false`.
 * @example
 *
 * _.isFunction(_);
 * // => true
 *
 * _.isFunction(/abc/);
 * // => false
 */
function isFunction(value) {
  // The use of `Object#toString` avoids issues with the `typeof` operator
  // in older versions of Chrome and Safari which return 'function' for regexes
  // and Safari 8 which returns 'object' for typed array constructors.
  return isObject(value) && objToString.call(value) == funcTag;
}

module.exports = isFunction;

},{"./isObject":44}],42:[function(require,module,exports){
var isFunction = require('./isFunction'),
    isObjectLike = require('../internal/isObjectLike');

/** Used to detect host constructors (Safari > 5). */
var reIsHostCtor = /^\[object .+?Constructor\]$/;

/** Used for native method references. */
var objectProto = Object.prototype;

/** Used to resolve the decompiled source of functions. */
var fnToString = Function.prototype.toString;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/** Used to detect if a method is native. */
var reIsNative = RegExp('^' +
  fnToString.call(hasOwnProperty).replace(/[\\^$.*+?()[\]{}|]/g, '\\$&')
  .replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, '$1.*?') + '$'
);

/**
 * Checks if `value` is a native function.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a native function, else `false`.
 * @example
 *
 * _.isNative(Array.prototype.push);
 * // => true
 *
 * _.isNative(_);
 * // => false
 */
function isNative(value) {
  if (value == null) {
    return false;
  }
  if (isFunction(value)) {
    return reIsNative.test(fnToString.call(value));
  }
  return isObjectLike(value) && reIsHostCtor.test(value);
}

module.exports = isNative;

},{"../internal/isObjectLike":36,"./isFunction":41}],43:[function(require,module,exports){
var isObjectLike = require('../internal/isObjectLike');

/** `Object#toString` result references. */
var numberTag = '[object Number]';

/** Used for native method references. */
var objectProto = Object.prototype;

/**
 * Used to resolve the [`toStringTag`](http://ecma-international.org/ecma-262/6.0/#sec-object.prototype.tostring)
 * of values.
 */
var objToString = objectProto.toString;

/**
 * Checks if `value` is classified as a `Number` primitive or object.
 *
 * **Note:** To exclude `Infinity`, `-Infinity`, and `NaN`, which are classified
 * as numbers, use the `_.isFinite` method.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is correctly classified, else `false`.
 * @example
 *
 * _.isNumber(8.4);
 * // => true
 *
 * _.isNumber(NaN);
 * // => true
 *
 * _.isNumber('8.4');
 * // => false
 */
function isNumber(value) {
  return typeof value == 'number' || (isObjectLike(value) && objToString.call(value) == numberTag);
}

module.exports = isNumber;

},{"../internal/isObjectLike":36}],44:[function(require,module,exports){
/**
 * Checks if `value` is the [language type](https://es5.github.io/#x8) of `Object`.
 * (e.g. arrays, functions, objects, regexes, `new Number(0)`, and `new String('')`)
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is an object, else `false`.
 * @example
 *
 * _.isObject({});
 * // => true
 *
 * _.isObject([1, 2, 3]);
 * // => true
 *
 * _.isObject(1);
 * // => false
 */
function isObject(value) {
  // Avoid a V8 JIT bug in Chrome 19-20.
  // See https://code.google.com/p/v8/issues/detail?id=2291 for more details.
  var type = typeof value;
  return !!value && (type == 'object' || type == 'function');
}

module.exports = isObject;

},{}],45:[function(require,module,exports){
var isObjectLike = require('../internal/isObjectLike');

/** `Object#toString` result references. */
var stringTag = '[object String]';

/** Used for native method references. */
var objectProto = Object.prototype;

/**
 * Used to resolve the [`toStringTag`](http://ecma-international.org/ecma-262/6.0/#sec-object.prototype.tostring)
 * of values.
 */
var objToString = objectProto.toString;

/**
 * Checks if `value` is classified as a `String` primitive or object.
 *
 * @static
 * @memberOf _
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is correctly classified, else `false`.
 * @example
 *
 * _.isString('abc');
 * // => true
 *
 * _.isString(1);
 * // => false
 */
function isString(value) {
  return typeof value == 'string' || (isObjectLike(value) && objToString.call(value) == stringTag);
}

module.exports = isString;

},{"../internal/isObjectLike":36}],46:[function(require,module,exports){
var getNative = require('../internal/getNative'),
    isArrayLike = require('../internal/isArrayLike'),
    isObject = require('../lang/isObject'),
    shimKeys = require('../internal/shimKeys');

/* Native method references for those with the same name as other `lodash` methods. */
var nativeKeys = getNative(Object, 'keys');

/**
 * Creates an array of the own enumerable property names of `object`.
 *
 * **Note:** Non-object values are coerced to objects. See the
 * [ES spec](http://ecma-international.org/ecma-262/6.0/#sec-object.keys)
 * for more details.
 *
 * @static
 * @memberOf _
 * @category Object
 * @param {Object} object The object to query.
 * @returns {Array} Returns the array of property names.
 * @example
 *
 * function Foo() {
 *   this.a = 1;
 *   this.b = 2;
 * }
 *
 * Foo.prototype.c = 3;
 *
 * _.keys(new Foo);
 * // => ['a', 'b'] (iteration order is not guaranteed)
 *
 * _.keys('hi');
 * // => ['0', '1']
 */
var keys = !nativeKeys ? shimKeys : function(object) {
  var Ctor = object == null ? undefined : object.constructor;
  if ((typeof Ctor == 'function' && Ctor.prototype === object) ||
      (typeof object != 'function' && isArrayLike(object))) {
    return shimKeys(object);
  }
  return isObject(object) ? nativeKeys(object) : [];
};

module.exports = keys;

},{"../internal/getNative":32,"../internal/isArrayLike":33,"../internal/shimKeys":37,"../lang/isObject":44}],47:[function(require,module,exports){
var isArguments = require('../lang/isArguments'),
    isArray = require('../lang/isArray'),
    isIndex = require('../internal/isIndex'),
    isLength = require('../internal/isLength'),
    isObject = require('../lang/isObject');

/** Used for native method references. */
var objectProto = Object.prototype;

/** Used to check objects for own properties. */
var hasOwnProperty = objectProto.hasOwnProperty;

/**
 * Creates an array of the own and inherited enumerable property names of `object`.
 *
 * **Note:** Non-object values are coerced to objects.
 *
 * @static
 * @memberOf _
 * @category Object
 * @param {Object} object The object to query.
 * @returns {Array} Returns the array of property names.
 * @example
 *
 * function Foo() {
 *   this.a = 1;
 *   this.b = 2;
 * }
 *
 * Foo.prototype.c = 3;
 *
 * _.keysIn(new Foo);
 * // => ['a', 'b', 'c'] (iteration order is not guaranteed)
 */
function keysIn(object) {
  if (object == null) {
    return [];
  }
  if (!isObject(object)) {
    object = Object(object);
  }
  var length = object.length;
  length = (length && isLength(length) &&
    (isArray(object) || isArguments(object)) && length) || 0;

  var Ctor = object.constructor,
      index = -1,
      isProto = typeof Ctor == 'function' && Ctor.prototype === object,
      result = Array(length),
      skipIndexes = length > 0;

  while (++index < length) {
    result[index] = (index + '');
  }
  for (var key in object) {
    if (!(skipIndexes && isIndex(key, length)) &&
        !(key == 'constructor' && (isProto || !hasOwnProperty.call(object, key)))) {
      result.push(key);
    }
  }
  return result;
}

module.exports = keysIn;

},{"../internal/isIndex":34,"../internal/isLength":35,"../lang/isArguments":39,"../lang/isArray":40,"../lang/isObject":44}],48:[function(require,module,exports){
/**
 * This method returns the first argument provided to it.
 *
 * @static
 * @memberOf _
 * @category Utility
 * @param {*} value Any value.
 * @returns {*} Returns `value`.
 * @example
 *
 * var object = { 'user': 'fred' };
 *
 * _.identity(object) === object;
 * // => true
 */
function identity(value) {
  return value;
}

module.exports = identity;

},{}],49:[function(require,module,exports){
 CliModule = require('bpmn-js-cli');
 console.log(CliModule);
},{"bpmn-js-cli":1}]},{},[49]);
