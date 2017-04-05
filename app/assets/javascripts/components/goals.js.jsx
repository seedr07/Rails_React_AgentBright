var Goals = React.createClass({
  mixins: [React.addons.LinkedStateMixin],

  getInitialState: function() {
    var goal = this.props.initialGoalWizard.goal;
    var user = this.props.initialGoalWizard.user;

    return {
      monthly_broker_fees: user.monthly_broker_fees_paid,
      has_franchise_fee: user.franchise_fee,
      franchise_fee: user.franchise_fee_per_transaction,
      commission_split_type: user.commission_split_type,
      split_percentage: user.agent_percentage_split,
      split_fee: user.broker_fee_per_transaction,
      has_fee_alternative: user.broker_fee_alternative,
      
      desired_annual_income: goal.desired_annual_income,
      est_business_expenses: goal.est_business_expenses,
      broker_percentage: 75,
      avg_commission_rate: goal.avg_commission_rate,
      average_sales_price: goal.avg_price_in_area,
      touches_per_referral: goal.contacts_to_generate_one_referral,
      referrals_per_closed_sale: goal.referrals_for_one_close,
      goal_id: goal.id
    };
  },

  handleDesiredAnnualIncomeChange: function(event) {
    this.setState({desired_annual_income: event.target.value});
  },

  handleEstBusinessExpensesChange: function(event) {
    this.setState({est_business_expenses: event.target.value});
  },

  handleBrokerPercentageChange: function(event) {
    this.setState({broker_percentage: event.target.value});
  },

  handleAverageSalesPrice: function(event) {
    this.setState({average_sales_price: event.target.value});
  },

  handleSubmit: function(event) {
    event.preventDefault();
    var id = "/goals/" + this.state.goal_id + "/update_goal_from_wizard";
    var data = {
      goal: {
        desired_annual_income: numbro().unformat(this.state.desired_annual_income),
        est_business_expenses: numbro().unformat(this.state.est_business_expenses),
        avg_commission_rate: this.state.avg_commission_rate,
        avg_price_in_area: numbro().unformat(this.state.average_sales_price),
        contacts_to_generate_one_referral: this.state.touches_per_referral,
        referrals_for_one_close: this.state.referrals_per_closed_sale
      }
    };

    $.ajax({
      method: "PATCH",
      url: id,
      data: data,
      dataType: "json",
      success: ( (data) => {
        toastr.success("Saved.");
      })
    });
  },


  render: function() {
    var total = parseInt(this.state.desired_annual_income, 10) + parseInt(this.state.est_business_expenses, 10);

    var gross_commission_goal = (parseInt(numbro().unformat(this.state.desired_annual_income), 10) + parseInt(numbro().unformat(this.state.est_business_expenses), 10)) / (parseFloat(this.state.broker_percentage) / 100.0);

    var sales_volume_needed = gross_commission_goal / (parseFloat(this.state.avg_commission_rate) / 100);
    var annual_transactions = sales_volume_needed / parseInt(numbro().unformat(this.state.average_sales_price));
    var quarterly_transactions = annual_transactions / 4;
    var monthly_transactions = annual_transactions / 12;

    var touches_per_closed_sale = parseInt(this.state.touches_per_referral, 10) * parseInt(this.state.referrals_per_closed_sale, 10);

    var annual_activities = annual_transactions * touches_per_closed_sale;
    var weekly_activities = annual_activities / 50;
    var weekly_calls = Math.ceil(weekly_activities * 0.35);
    var weekly_notes = Math.ceil(weekly_activities * 0.50);
    var weekly_visits = Math.ceil(weekly_activities * 0.15);
    var total_weekly_activities = weekly_calls + weekly_notes + weekly_visits;

    var daily_activities = weekly_activities / 4;
    var daily_calls = Math.ceil(daily_activities * 0.35);
    var daily_notes = Math.ceil(daily_activities * 0.50);
    var daily_visits = Math.ceil(daily_activities * 0.15);
    var total_daily_activities = daily_calls + daily_notes + daily_visits;

    return (
      <form onSubmit={this.handleSubmit}>
        <CurrencyInput
          label="Desired Annual Income"
          value={this.state.desired_annual_income}
          whenChanged={this.handleDesiredAnnualIncomeChange}
          />
        <CurrencyInput
          label="Estimated Business Expenses"
          value={this.state.est_business_expenses}
          whenChanged={this.handleEstBusinessExpensesChange}
          />
        <PercentageInput
          label="My Side of Broker/Agent Split"
          value={this.state.broker_percentage}
          whenChanged={this.handleBrokerPercentageChange}
          />
        <h4>Gross Commission Goal: ${numbro(Math.round(gross_commission_goal)).format("0,0")}</h4>
        <Input valueLink={this.linkState("avg_commission_rate")} label="Average Commission Rate" />
        <h4>Sales Volume Needed: ${numbro(Math.round(sales_volume_needed)).format("0,0")}</h4>
        <CurrencyInput
          label="My Average Sale Price (last 12 months)"
          value={this.state.average_sales_price}
          whenChanged={this.handleAverageSalesPrice}
          />
        <h4>Annual Transactions: {Math.round(annual_transactions)}</h4>
        <h4>Quarterly Transactions: {Math.round(quarterly_transactions)}</h4>
        <h4>Monthly Transactions: {Math.round(monthly_transactions)}</h4>
        <Input valueLink={this.linkState("touches_per_referral")} label="Touches per referral" />
        <Input valueLink={this.linkState("referrals_per_closed_sale")} label="Referrals per closed sale" />
        <h4>Weekly activities: {Math.round(total_weekly_activities)}</h4>
        <p>
          Calls: {weekly_calls}<br />
          Notes: {weekly_notes}<br />
          Visits: {weekly_visits}
        </p>
        <h4>Daily activities: {Math.round(total_daily_activities)}</h4>
        <p>
          Calls: {daily_calls}<br />
          Notes: {daily_notes}<br />
          Visits: {daily_visits}
        </p>
        <button type="submit" className="btn btn-default btn-paper btn-raised btn-loading">Save Goals</button>
      </form>
    );
  }

});

var CurrencyInput = React.createClass({
  handleChange: function() {
    this.props.whenChanged(this.props.value);
  },

  render: function() {
    return (
      <div className="form-group">
        <label>{this.props.label}</label>
        <input
          type="text"
          className="form-control max200"
          value={numbro(this.props.value).formatCurrency("0,0")}
          onChange={this.props.whenChanged}
          />
      </div>
    );
  }
});

var PercentageInput = React.createClass({
  handleChange: function() {
    this.props.whenChanged(this.props.value);
  },

  render: function() {
    return (
      <div className="form-group">
        <label>{this.props.label}</label>
        <input
          type="text"
          className="form-control max200"
          value={this.props.value}
          onChange={this.props.whenChanged}
          />
      </div>
    );
  }
});

var Input = React.createClass({
  render: function() {
    var props = this.props;
    var label = this.props.label;
    return (
      <div className="form-group">
        <label>{label}</label>
        <input type="text" className="form-control max200" {...props} />
      </div>
    );
  }
});
