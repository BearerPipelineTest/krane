# frozen_string_literal: true
require 'test_helper'
require 'kubernetes-deploy/runner_task'

class RunnerTaskUnitTest < KubernetesDeploy::TestCase
  def setup
    Kubeclient::Client.any_instance.stubs(:discover)
    super
  end

  def test_run_with_invalid_configuration
    task_runner = KubernetesDeploy::RunnerTask.new(
      context: KubeclientHelper::MINIKUBE_CONTEXT,
      namespace: nil,
      logger: logger,
    )

    refute task_runner.run(task_template: nil, entrypoint: nil, args: nil)
    assert_logs_match(/Task template name can't be nil/i)
    assert_logs_match(/Namespace can't be empty/i)
    assert_logs_match(/Args can't be nil/i)
  end

  def test_run_bang_with_invalid_configuration
    task_runner = KubernetesDeploy::RunnerTask.new(
      context: KubeclientHelper::MINIKUBE_CONTEXT,
      namespace: nil,
      logger: logger,
    )

    err = assert_raises(KubernetesDeploy::RunnerTask::FatalTaskRunError) do
      task_runner.run!(task_template: nil, entrypoint: nil, args: nil)
    end

    assert_match(/Task template name can't be nil/i, err.to_s)
    assert_match(/Namespace can't be empty/i, err.to_s)
    assert_match(/Args can't be nil/i, err.to_s)
  end
end
